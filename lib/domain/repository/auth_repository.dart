import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity?> authenticate(AuthEntity entity);
  Future<void> saveCredentials(AuthEntity entity);
  Future<AuthEntity?> loadCredentials();

  // 他API呼び出し時に認証情報を付与
  Future<Map<String, String>> buildAuthHeaders(AuthEntity entity);
}
