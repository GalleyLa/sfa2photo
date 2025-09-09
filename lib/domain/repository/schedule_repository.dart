import '../entity/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> fetchRemote();
  Future<void> saveLocal(List<ScheduleEntity> schedules);
  Future<List<ScheduleEntity>> loadLocal();
  Future<List<ScheduleEntity>> getAllCustomers();
}
