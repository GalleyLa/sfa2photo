// lib/infrastructure/service/schedule_api_service.dart

import 'package:flutter/foundation.dart';

import 'base_api_service.dart';

class ScheduleApiService {
  final BaseApiService baseApiService;

  ScheduleApiService(this.baseApiService);

  Future<Map<String, dynamic>> fetchSchedules(String tenantId) async {
    try {
      final response = await baseApiService.post(
        '',
        data: {
          '_search_pattern': 'month',
          'schedule_date_from': '2025/09/18',
          'schedule_mode': 'member',
          '_search_org_id': '3586',
          'schedule_member_id': '74',
          '_search_facility_category_id': '25',
          '_search_gschedule_category_id': '12',
          '_search_schedule_category_id': '',
          '_search_facility_ids': '',
          '_search_current_date': '',
          'editable': 'true',
          'schedule_single_print': 'false',
        },

        queryParameters: {
          'module': 'office',
          'controller': 'schedule',
          'exec': 'get-graph-data',
          'time': '1758180281133',
        },
      );

      /*   '_search_pattern': 'month',
        'schedule_date_from': '2025/09/18',
        'schedule_mode': 'member',
        '_search_org_id': '3586',
        'schedule_member_id': '74',
        '_search_facility_category_id': '25',
        '_search_gschedule_category_id': '12',
        '_search_schedule_category_id': '',
        '_search_facility_ids': '',
        '_search_current_date': '',
        'editable': 'true',
        'schedule_single_print': 'false',
        */
      debugPrint("response: ${response.data}");

      return {
        "success": true,
        "data": {"id": '74', "name": "test"},
        // "cookies": cookieStrings,
      };
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }
}

/*
class ScheduleApiService {
  final BaseApiService baseApiService;

  ScheduleApiService(this.baseApiService);

  Future<List<ScheduleEntity>> fetchScheduleList() async {
    final response = await baseApiService.get(
      '/data/detail',
      queryParameters: {
        'fid': '-1',
        'fvid': '-1',
        'cid': '69420',
        'layout': 'detail',
        'type': 'plan',
      },
    );
    final list = response.data as List<dynamic>;
    return list.map((e) => ScheduleEntity.fromMap(e)).toList();
    //return response.data;
  }
}
*/
///oec/?module=office&controller=schedule&exec=get-graph-data&time=1757301372455
/*
_search_pattern	"month"
schedule_date_from	"2025/09/08" //ここが変わる
schedule_mode	"member"
_search_org_id	"3586"
schedule_member_id	"74" //ここが変わる
_search_facility_category_id	"25"
_search_gschedule_category_id	"12"
_search_schedule_category_id	""
_search_facility_ids	""
_search_current_date	""
editable	"true"
schedule_single_print	"false"
*/

/*
 final String baseUrl;

  late Dio _dio;
  late CookieJar _cookieJar;

  authenticate({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar)); // ★Cookie自動管理
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  //グループウエアのログイン
  Future<Map<String, dynamic>> login(String userId, String password) async {
    try {
      // Step 1: ログイン
      await _dio.post(
        '',
        data: {'user_id': userId, 'password': password, 'login_form': '2'},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status < 400, //ログインが成功すると302リダイレクト
        ),
      );

      // Cookieからmember_idを抽出 ログインが成功していればCookieに含まれる
      final cookies = await _cookieJar.loadForRequest(Uri.parse(baseUrl));
      final memberCookie = cookies.firstWhere(
        (c) => c.name == 'member_id',
        orElse: () => Cookie('', ''),
      );
      if (memberCookie.name.isEmpty)
        throw Exception("member_idがCookieに含まれていません");

      debugPrint("member_id: ${memberCookie.value}");

      //final memberId = memberCookie.value;
      return {
        "success": true,
        "data": {"id": memberCookie.value, "name": "test"},
      };
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }
  */
