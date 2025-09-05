import '../domain/entities/auth_entity.dart';
import '../domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<bool> execute(AuthEntity entity) async {
    final success = await repository.authenticate(entity);
    if (success) {
      await repository.saveCredentials(entity);
      return true;
    }
    return false;
  }
}
