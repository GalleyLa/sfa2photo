// lib/data/local/db/tables/user_table.dart
class UserTable {
  static const String tableName = 'users';
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';

  // CREATE TABLE 文などもまとめることが可能
  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL,
      $email TEXT NOT NULL
    )
  ''';
}
