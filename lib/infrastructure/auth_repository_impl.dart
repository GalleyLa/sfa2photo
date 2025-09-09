import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import './service/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.apiService, this.secureStorage);

  @override
  Future<AuthEntity?> authenticate(AuthEntity entity) async {
    final result = await apiService.login(entity.username, entity.password);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      // return entity.copyWith(
      //   id: data['id']?.toString(),
      //   name: data['name']?.toString(),
      // );
      // final cookies =
      //     result['cookies'] as List<String>; // ← AuthApiService で抽出して返すように修正
      final authEntity = entity.copyWith(
        id: data['id']?.toString(),
        name: data['name']?.toString(),
        // cookies: cookies,
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
    // if (entity.cookies != null) {
    //   await secureStorage.write(
    //     key: 'cookies',
    //     value: entity.cookies!.join(';'),
    //   );
    // }
  }

  @override
  Future<AuthEntity?> loadCredentials() async {
    final username = await secureStorage.read(key: 'username');
    final password = await secureStorage.read(key: 'password');
    if (username == null || password == null) return null;

    final id = await secureStorage.read(key: 'user_id');
    final name = await secureStorage.read(key: 'user_name');
    // final cookieStr = await secureStorage.read(key: 'cookies');
    // final cookies = cookieStr?.split(';');

    return AuthEntity(
      username: username,
      password: password,
      id: id,
      name: name,
      // cookies: cookies,
    );
  }

  @override
  Future<Map<String, String>> buildAuthHeaders(AuthEntity entity) async {
    final headers = <String, String>{};
    // Uncomment and adjust the following lines if your AuthEntity has cookies or id fields
    // if (entity.cookies != null) {
    //   headers['Cookie'] = entity.cookies!.join('; ');
    // }
    if (entity.id != null) {
      headers['X-User-Id'] = entity.id!;
    }
    return headers;
  }
}
