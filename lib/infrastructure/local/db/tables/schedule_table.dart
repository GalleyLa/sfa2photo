//

import 'package:sqflite/sqflite.dart';

class ScheduleTable {
  static const String tableName = 'schedules';
  static const String id = 'id';
  static const String mode = 'mode';
  static const String memberId = 'member_id';
  static const String scheduleId = 'schedule_id';
  static const String mouseTitle = 'mouse_title';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String scheduleDate = 'schedule_date';
  static const String allDay = 'all_day';
  static const String aplResourceDataKey = 'apl_resource_data_key';
  static const String createdAt = 'created_at'; // 作成日
  static const String updatedAt = 'updated_at'; // 更新日
  static const String deletedAt = 'deleted_at'; // 削除日。未削除ならNULL

  // CREATE TABLE 文などもまとめることが可能
  //static const String createTableQuery =
  /// CREATE TABLE 文を返す
  static String createTableQuery() {
    return '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $mode TEXT,
      $memberId TEXT,
      $scheduleId TEXT,
      $mouseTitle TEXT,
      $startDate TEXT,
      $endDate TEXT,
      $scheduleDate TEXT,
      $allDay INTEGER,
      $aplResourceDataKey TEXT,
      $createdAt TEXT,
      $updatedAt TEXT,
      $deletedAt TEXT,
      UNIQUE ($scheduleId, $scheduleDate) 
    );
  ''';
  }

  /// テーブル作成をDBに適用
  static Future<void> createTable(Database db) async {
    await db.execute(createTableQuery());
  }
}
