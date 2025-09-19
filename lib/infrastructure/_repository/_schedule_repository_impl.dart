/*
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService scheduleApi;
  final CustomerApiService customerApi;
  final LocalDatabaseService db;

  ScheduleRepositoryImpl(this.scheduleApi, this.customerApi, this.db);

  @override
  Future<List<ScheduleEntity>> fetchRemote() async {
    // 1. スケジュール一覧を取得
    final schedulesRaw = await scheduleApi.fetchSchedules();
    final schedules = schedulesRaw
        .map((e) => ScheduleEntity.fromMap(e))
        .toList();

    // 2. 各スケジュールに対して顧客を取得
    for (final schedule in schedules) {
      final customer = await customerApi.fetchCustomer(schedule.id);
      if (customer != null) {
        await db.saveCustomer(customer.toMap());
      }
    }

    // 3. スケジュールを保存
    await db.saveSchedules(schedules.map((e) => e.toMap()).toList());

    return schedules;
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
