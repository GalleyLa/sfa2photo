// lib/infrastructure/schedule_repository_impl.dart

import 'package:flutter/foundation.dart';
import 'package:sfa2photo/infrastructure/local/datasources/schedule_local_datasource.dart';

import '../../../domain/entity/schedule_entity.dart';
import '../../../domain/repository/schedule_repository.dart';
import '../service/schedule_api_service.dart';
import '../../domain/models/schedule_api_model.dart';
//import '../../domain/models/schedule_db_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService apiService;
  final ScheduleLocalDataSource localDb;

  ScheduleRepositoryImpl({required this.apiService, required this.localDb});

  @override
  Future<List<ScheduleEntity>> fetchRemote() async {
    final result = await apiService.fetchSchedules(); // tenantId は仮
    //httpレスポンスの成否を確認
    if (result['success'] == true) {
      // APIが成功したかをチェック
      if (result['data']['error'] == false) {
        final List<dynamic> allItems = result['data']['data']['result'];

        // modeを含むデータのみ抽出（スケジュールのみ）
        final filteredItems = allItems
            .where((e) => e.containsKey('mode'))
            .toList();

        // APIモデル経由でEntityへ変換
        return filteredItems
            .map(
              (e) => ScheduleApiModel.fromMap(
                e as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();
      } else {
        // 失敗時はエラーを投げる（メッセージがあれば含める）
        final message = result['message']?.toString() ?? 'Unknown error';
        throw Exception('Failed to fetch schedules: $message');
      }
    } else {
      throw Exception('Failed to fetch schedules: ${result['data']}');
    }
  }

  @override
  Future<void> saveLocal(List<ScheduleEntity> schedules) async {
    await localDb.saveSchedules(schedules);
  }

  @override
  Future<List<ScheduleEntity>> loadLocal() async {
    return await localDb.getSchedules();
  }

  @override
  Future<List<ScheduleEntity>> getAllCustomers() async {
    // TODO: Implement getAllCustomers logic or throw UnimplementedError if not supported
    throw UnimplementedError('getAllCustomers is not implemented');
  }

  @override
  Future<List<ScheduleEntity>> getSchedules() async {
    // TODO: Implement getSchedules logic or throw UnimplementedError if not supported
    throw UnimplementedError('getSchedules is not implemented');
  }
}
