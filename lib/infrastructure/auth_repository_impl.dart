import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/auth_entity.dart';
import '../domain/repository/auth_repository.dart';
import './service/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.apiService, this.secureStorage);

  @override
  Future<bool> authenticate(AuthEntity entity) async {
    final result = await apiService.authenticate(
      entity.username,
      entity.password,
    );
    // APIの戻り値は {"success": true/false, "data": {...}}
    if (result['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<void> saveCredentials(AuthEntity entity) async {
    await secureStorage.write(key: 'username', value: entity.username);
    await secureStorage.write(key: 'password', value: entity.password);
  }
}
