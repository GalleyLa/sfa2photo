// lib/application/usecases/schedule_usecase.dart
import '../../domain/entity/schedule_entity.dart';
import '../../domain/repository/schedule_repository.dart';

// スケジュールのデータ構造
// スケジュールの取得、保存、ローカル読み込み
class ScheduleUseCase {
  final ScheduleRepository
  repository; // 依存性注入 (infrastructure/schedule_repository_impl.dart)

  ScheduleUseCase(this.repository);

  // domain/repository/schedule_repository.dart の fetchRemote を呼び出す
  // Future<List<ScheduleEntity>> fetchRemoteSchedules() async {
  //   return await repository.fetchRemote();
  // }
  Future<List<ScheduleEntity>> execute() async {
    // 例: リモートから取得してローカルに保存もする
    final schedules = await repository.fetchRemote();
    // await repository.saveLocal(schedules);
    return schedules;
  }
}
