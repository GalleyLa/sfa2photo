// lib/application/usecases/load_schedules_usecase.dart
import '../../domain/entity/schedule_entity.dart';
import '../../domain/repository/schedule_repository.dart';

class LoadSchedulesUseCase {
  final ScheduleRepository repository;
  LoadSchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> execute() async {
    return await repository.loadLocal();
  }
}
