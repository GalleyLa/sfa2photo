// domain/repositories/password_repository.dart
import '../entities/password.dart';

abstract class PasswordRepository {
  Future<void> savePassword(Password password);
  Future<Password?> getPassword();
}
