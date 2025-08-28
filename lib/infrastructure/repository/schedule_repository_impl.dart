// infrastructure/repository/schedule_repository_impl.dart
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApi api;
  final ScheduleDao dao;

  ScheduleRepositoryImpl({required this.api, required this.dao});

  @override
  Future<List<Schedule>> fetchAndCacheSchedules(String memberId) async {
    final schedules = await api.fetchSchedules(memberId);
    await dao.insertSchedules(schedules);
    return schedules;
  }

  @override
  Future<List<Schedule>> getSchedulesFromCache(String customerId) {
    return dao.getSchedulesByCustomer(customerId);
  }

  @override
  Future<void> syncSchedules(String memberId) async {
    // APIから取得
    final remoteSchedules = await api.fetchSchedules(memberId);
    final localSchedules = await dao.getSchedulesByMember(memberId);

    // 比較用Map（idをキーにする）
    final localMap = {for (var s in localSchedules) s.id: s};
    final remoteMap = {for (var s in remoteSchedules) s.id: s};

    // トランザクションで一括更新
    await dao.runInTransaction((txn) async {
      // 新規 or 更新
      for (final remote in remoteSchedules) {
        final local = localMap[remote.id];
        if (local == null) {
          await dao.insertSchedule(remote, txn: txn); // 新規
        } else if (remote.updatedAt.isAfter(local.updatedAt)) {
          await dao.updateSchedule(remote, txn: txn); // 更新
        }
      }

      // 削除（ローカルにあるがリモートに存在しないもの）
      for (final local in localSchedules) {
        if (!remoteMap.containsKey(local.id)) {
          await dao.deleteSchedule(local.id, txn: txn);
        }
      }
    });
  }
}
