import 'package:sqflite/sqflite.dart';
import '../../../domain/entity/schedule_entity.dart';

class ScheduleLocalDataSource {
  final Database db;
  static const tableName = 'schedules';

  ScheduleLocalDataSource(this.db);

  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    final batch = db.batch();
    for (final s in schedules) {
      batch.insert(
        tableName,
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ScheduleEntity>> getSchedules() async {
    final rows = await db.query(tableName, orderBy: 'startDate ASC');
    return rows.map((r) => ScheduleEntity.fromMap(r)).toList();
  }

  Future<ScheduleEntity?> getScheduleById(int id) async {
    final rows = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ScheduleEntity.fromMap(rows.first);
  }

  Future<void> clearSchedules() async {
    await db.delete(tableName);
  }
}
