// lib/infrastructure/usecases/schedule_localdb_impl.dart

import '../../../domain/entity/schedule_entity.dart';
import '../../../domain/repository/schedule_repository.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleLocalDbImpl implements ScheduleLocalDb {
  final Database database;

  ScheduleLocalDbImpl(this.database);

  @override
  Future<List<ScheduleEntity>> getSchedules() async {
    final maps = await database.query('schedules', orderBy: 'date DESC');
    return maps.map((m) => ScheduleEntity.fromMap(m)).toList();
  }

  @override
  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    final batch = database.batch();
    await database.delete('schedules'); // 全削除（例：同期のたびに全更新）

    for (final s in schedules) {
      batch.insert('schedules', s.toMap());
    }

    await batch.commit(noResult: true);
  }
}
