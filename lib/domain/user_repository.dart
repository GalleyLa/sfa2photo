// domain/user_repository.dart
import 'user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser(String id);
}
