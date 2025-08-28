// application/get_schedules_usecase.dart
import '../domain/schedule.dart';
import '../domain/schedule_repository.dart';

class GetSchedulesUseCase {
  final ScheduleRepository repository;
  GetSchedulesUseCase(this.repository);

  Future<List<Schedule>> execute(
    String memberId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      // APIから取得してキャッシュ更新
      return await repository.fetchAndCacheSchedules(memberId);
    } else {
      // SQLiteから取得
      return await repository.getSchedulesFromCache(memberId);
    }
  }
}
