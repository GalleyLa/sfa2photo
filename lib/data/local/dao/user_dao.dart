// lib/data/local/dao/user_dao.dart
import 'package:sqflite/sqflite.dart';
import '../db/tables/user_table.dart';

class UserDao {
  final Database db;

  UserDao(this.db);

  Future<int> insertUser(Map<String, dynamic> user) async {
    return await db.insert(UserTable.tableName, user);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final result = await db.query(
      UserTable.tableName,
      columns: [UserTable.id, UserTable.name, UserTable.email],
      where: '${UserTable.id} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }
}
