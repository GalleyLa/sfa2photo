// lib/infrastructure/service/database_api_service.dart

import '../local/dao/schedule_dao.dart';

class ScheduleLocalDb {
  final ScheduleDao scheduleDao;

  ScheduleLocalDb(this.scheduleDao);

  Future<void> saveData(Map<String, dynamic> data) async {
    // DriftやSqfliteで永続化
    await scheduleDao.insertSchedule(data);
  }

  Future<Map<String, dynamic>> loadData() async {
    // DBから読み出し
    return {};
  }

  Future<void> saveLocal(Map<String, dynamic> data) async {
    // DriftやSqfliteで永続化
    await scheduleDao.insertSchedule(data);
  }
}
