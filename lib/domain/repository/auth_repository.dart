import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<bool> authenticate(AuthEntity entity);
  Future<void> saveCredentials(AuthEntity entity);
}
