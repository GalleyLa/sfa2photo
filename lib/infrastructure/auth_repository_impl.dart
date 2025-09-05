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
}
