// data/repositories/password_repository_impl.dart
import '/domain/entities/password.dart';
import '/domain/repositories/password_repository.dart';
import '../datasources/secure_storage_datasource.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final SecureStorageDataSource dataSource;
  PasswordRepositoryImpl(this.dataSource);

  @override
  Future<void> savePassword(Password password) async {
    await dataSource.save('password', password.value);
  }

  @override
  Future<Password?> getPassword() async {
    final value = await dataSource.read('password');
    return value != null ? Password(value) : null;
  }
}
