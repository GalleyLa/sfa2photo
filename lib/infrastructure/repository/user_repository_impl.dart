// infrastructure/repository/user_repository_impl.dart
import 'package:sqflite/sqflite.dart';
import '../../domain/user.dart';
import '../../domain/user_repository.dart';
import '../database/app_database.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> saveUser(User user) async {
    final db = await AppDatabase.instance();
    await db.insert('users', {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'city': user.city,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<User?> getUser(String id) async {
    final db = await AppDatabase.instance();
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      final row = maps.first;
      return User(
        id: row['id'] as String,
        name: row['name'] as String,
        email: row['email'] as String,
        city: row['city'] as String,
      );
    }
    return null;
  }
}
