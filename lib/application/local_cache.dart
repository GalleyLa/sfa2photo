// infrastructure/local_cache.dart
import 'package:hive/hive.dart';
import '../domain/user.dart';

class LocalCache {
  static const String userBoxName = "userBox";

  Future<void> saveUser(User user) async {
    final box = await Hive.openBox(userBoxName);
    await box.put("user", {
      "id": user.id,
      "name": user.name,
      //"email": user.email,
      //"city": user.city,
    });
  }

  Future<User?> loadUser() async {
    final box = await Hive.openBox(userBoxName);
    final data = box.get("user");
    if (data == null) return null;

    return User(
      id: data["id"],
      name: data["name"],
      //email: data["email"],
      //city: data["city"],
    );
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox(userBoxName);
    await box.delete("user");
  }
}
