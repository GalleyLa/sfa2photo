// lib/infrastructure/usecases/schedule_localdb_impl.dart

import '../../../domain/entity/schedule_entity.dart';
import '../../../domain/repository/schedule_repository.dart';
//import 'package:sqflite/sqflite.dart';

class GetSchedulesUseCase {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> execute() async {
    return await repository.getSchedules();
  }
}
