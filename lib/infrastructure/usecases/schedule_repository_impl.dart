/*
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService scheduleApi;
  final CustomerApiService customerApi;
  final LocalDatabaseService db;

  ScheduleRepositoryImpl(this.scheduleApi, this.customerApi, this.db);

  @override
  Future<List<ScheduleEntity>> fetchRemote() async {
    // 1. スケジュール取得
    final schedulesRaw = await scheduleApi.fetchSchedules();

    // 2. 顧客取得
    final customersRaw = await customerApi.fetchCustomers();

    // 3. 顧客IDで突合
    final customers = customersRaw
        .map((e) => CustomerEntity.fromMap(e))
        .toList();
    final customerMap = {for (var c in customers) c.id: c};

    final schedules = schedulesRaw.map((map) {
      final schedule = ScheduleEntity.fromMap(map);
      final customer = customerMap[schedule.customerId];
      // 顧客が存在すればDB保存対象に追加
      if (customer != null) {
        db.saveCustomer(customer.toMap());
      }
      return schedule;
    }).toList();

    // 4. 保存
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
