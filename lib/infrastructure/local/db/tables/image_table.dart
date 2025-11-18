//

import 'package:sqflite/sqflite.dart';

class ImageTable {
  static const String tableName = 'images';
  static const String id = 'id';
  static const String scheduleId = 'schedule_id';
  static const String imagePath = 'image_path';
  static const String scheduleSelDate = 'schedule_sel_date';
  static const String createdAt = 'created_at'; // 作成日

  // CREATE TABLE 文などもまとめることが可能
  //static const String createTableQuery =
  /// CREATE TABLE 文を返す
  static String createTableQuery() {
    return '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $scheduleId TEXT NOT NULL, 
      $imagePath TEXT NOT NULL,
      $scheduleSelDate TEXT NOT NULL,
      $createdAt TEXT
    );
  ''';
  }

  /// テーブル作成をDBに適用
  static Future<void> createTable(Database db) async {
    await db.execute(createTableQuery());
  }
}
