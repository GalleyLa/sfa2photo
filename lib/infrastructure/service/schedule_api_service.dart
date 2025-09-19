// lib/infrastructure/service/schedule_api_service.dart

// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'base_api_service.dart';
import '../../shared/utils/date_formatter.dart';
// Add import for IDateFormatter if it's defined elsewhere
// import 'package:your_package/date_formatter.dart';

class ScheduleApiService {
  final BaseApiService baseApiService;
  final FlutterSecureStorage secureStorage;
  final IDateFormatter formatter;

  ScheduleApiService(this.baseApiService, this.secureStorage, this.formatter);

  final now = DateTime.now();
  String get formattedDate => formatter.format(now, pattern: 'yyyy/MM/dd');
  String get unixDate => formatter.toUnixTimestamp(now).toString();

  Future<String> getUserId() async {
    final userId = await secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("未ログイン状態です");
    return userId;
  }

  //スケジュールの取得
  Future<Map<String, dynamic>> fetchSchedules(String tenantId) async {
    try {
      // ここで await して userId を確実に取得してから使う
      final userId = await getUserId();

      final response = await baseApiService.post(
        '',
        data: {
          '_search_pattern': 'month',
          'schedule_date_from': formattedDate,
          'schedule_mode': 'member',
          //'_search_org_id': '3586',
          'schedule_member_id': userId,
          //'_search_facility_category_id': '25',
          //'_search_gschedule_category_id': '12',
          '_search_schedule_category_id': '',
          //'_search_facility_ids': '',
          //'_search_current_date': '',
          'editable': 'true',
          'schedule_single_print': 'false',
        },

        queryParameters: {
          'module': 'office',
          'controller': 'schedule',
          'exec': 'get-graph-data',
          'time': unixDate,
        },
      );

      //("response: ${response.data}");

      return {
        "success": true,
        "data": {response.data},
        // "cookies": cookieStrings,
      };
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }
}
