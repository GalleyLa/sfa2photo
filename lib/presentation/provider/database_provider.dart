import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../infrastructure/local/db/tables/schedule_table.dart';
import 'package:path/path.dart' as p;

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = p.join(dbPath, 'app_database.db');

  // DBを開く（なければ作成）
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await ScheduleTable.createTable(db); // ここを置き換え
    },
  );
});
