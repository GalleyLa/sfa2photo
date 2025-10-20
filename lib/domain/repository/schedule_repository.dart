// lib/domain/repository/schedule_repository.dart
import '../entity/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> fetchRemote();
  Future<void> saveLocal(List<ScheduleEntity> schedules);
  Future<List<ScheduleEntity>> loadLocal();
  Future<List<ScheduleEntity>> getSchedules();
  Future<List<ScheduleEntity>> getAllCustomers();
}

//abstract class ScheduleLocalDb {
//  Future<List<ScheduleEntity>> getSchedules();
//  Future<void> saveSchedules(List<ScheduleEntity> schedules);
//}
