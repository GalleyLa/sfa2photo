// infrastructure/database/app_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers(
            id TEXT PRIMARY KEY,
            name TEXT,
            address TEXT,
            phone TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE schedules(
            id TEXT PRIMARY KEY,
            customer_id TEXT,
            title TEXT,
            start TEXT,
            end TEXT,
            FOREIGN KEY(customer_id) REFERENCES customers(id)
          )
        ''');
      },
    );
    return _db!;
  }
}
