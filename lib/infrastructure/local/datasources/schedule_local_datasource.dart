import 'package:sqflite/sqflite.dart';
import '../../../domain/entity/schedule_entity.dart';
import '../../local/db/tables/schedule_table.dart';

class ScheduleLocalDataSource {
  final Database db;
  static const tableName = ScheduleTable.tableName;

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

  Future<List<ScheduleEntity>> loadSchedules() async {
    final maps = await db.query(tableName);
    return maps.map((e) => ScheduleEntity.fromMap(e)).toList();
  }

  Future<List<ScheduleEntity>> getSchedules() async {
    final rows = await db.query(
      tableName,
      orderBy: '${ScheduleTable.startDate} ASC',
    );
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
