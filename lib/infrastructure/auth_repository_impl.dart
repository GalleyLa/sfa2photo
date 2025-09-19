import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import './service/auth_api_service.dart';

// AuthRepository の具体的な実装
// API 通信とセキュアストレージの操作を担当
// AuthApiService と FlutterSecureStorage を注入して使用
// ここで例外が発生する可能性がある
// 例: ネットワークエラー、認証エラー、ストレージエラーなど
// 例外は上位に伝播させ、呼び出し元で適切に処理する
// 例: AuthUseCase や AuthNotifier でキャッチして状態を更新する
// 例外処理の詳細は省略し、簡易的に実装

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.apiService, this.secureStorage);

  @override
  Future<AuthEntity?> authenticate(AuthEntity entity) async {
    final result = await apiService.login(entity.username, entity.password);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      final authEntity = entity.copyWith(
        id: data['id']?.toString(),
        name: data['name']?.toString(),
      );

      await saveCredentials(authEntity);
      return authEntity;
    }
    return null;
  }

  @override
  Future<void> saveCredentials(AuthEntity entity) async {
    await secureStorage.write(key: 'username', value: entity.username);
    await secureStorage.write(key: 'password', value: entity.password);

    if (entity.id != null) {
      await secureStorage.write(key: 'user_id', value: entity.id);
    }
    if (entity.name != null) {
      await secureStorage.write(key: 'user_name', value: entity.name);
    }
  }

  @override
  Future<AuthEntity?> loadCredentials() async {
    final username = await secureStorage.read(key: 'username');
    final password = await secureStorage.read(key: 'password');
    if (username == null || password == null) return null;

    final id = await secureStorage.read(key: 'user_id');
    final name = await secureStorage.read(key: 'user_name');

    return AuthEntity(
      username: username,
      password: password,
      id: id,
      name: name,
    );
  }

  @override
  Future<Map<String, String>> buildAuthHeaders(AuthEntity entity) async {
    final headers = <String, String>{};

    if (entity.id != null) {
      headers['X-User-Id'] = entity.id!;
    }
    return headers;
  }
}
