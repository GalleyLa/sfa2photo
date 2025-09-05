import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity?> authenticate(AuthEntity entity);
  Future<void> saveCredentials(AuthEntity entity);
}
