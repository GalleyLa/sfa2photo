// lib/infrastructure/local/dao/schedule_dao.dart --- IGNORE ---

import 'package:sqflite/sqflite.dart';
import '../db/tables/schedule_table.dart';

class ScheduleDao {
  final Database db;

  ScheduleDao(this.db);

  Future<void> insertSchedule(Map<String, dynamic> schedule) async {
    await db.insert(
      ScheduleTable.tableName,
      schedule,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getScheduleById(int id) async {
    return await db.rawQuery(getScheduleByIdQuery, [id]);
  }
}

Future<void> insertSchedule(Database db, Map<String, dynamic> schedule) async {
  await db.insert(
    ScheduleTable.tableName,
    schedule,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// query example
String getScheduleByIdQuery =
    '''
SELECT ${ScheduleTable.id}, ${ScheduleTable.mouseTitle}, ${ScheduleTable.startDate}, ${ScheduleTable.endDate}
FROM ${ScheduleTable.tableName}
WHERE ${ScheduleTable.id} = ?
''';
