/*
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService apiService;
  final LocalDatabaseService db;

  ScheduleRepositoryImpl(this.apiService, this.db);

  @override
  Future<List<ScheduleEntity>> fetchRemote() async {
    final result = await apiService.fetchSchedulesWithCustomers();

    // schedules & customers を分解してDB保存
    await db.saveSchedules(result['schedules']);
    await db.saveCustomers(result['customers']);

    return result['schedules']
        .map<ScheduleEntity>((e) => ScheduleEntity.fromMap(e))
        .toList();
  }

  @override
  Future<void> saveLocal(List<ScheduleEntity> schedules) async {
    await db.saveSchedules(schedules.map((e) => e.toMap()).toList());
  }

  @override
  Future<List<ScheduleEntity>> loadLocal() async {
    final list = await db.loadSchedules();
    return list.map((e) => ScheduleEntity.fromMap(e)).toList();
  }
}
*/
