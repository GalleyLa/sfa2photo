// infrastructure/database/schedule_dao.dart
import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../../domain/schedule.dart';

class ScheduleDao {
  Future<void> insertSchedules(List<Schedule> schedules) async {
    final db = await AppDatabase.instance();
    final batch = db.batch();
    for (final s in schedules) {
      batch.insert(
        'schedules',
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Schedule>> getSchedulesByCustomer(String customerId) async {
    final db = await AppDatabase.instance();
    final maps = await db.query(
      'schedules',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );

    return maps.map((row) => Schedule.fromMap(row)).toList();
  }
}
