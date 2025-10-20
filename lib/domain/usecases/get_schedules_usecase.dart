import '../repository/schedule_repository.dart';
import '../entity/schedule_entity.dart';

class GetSchedulesUseCase {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> execute() async {
    return await repository.getSchedules();
  }
}
