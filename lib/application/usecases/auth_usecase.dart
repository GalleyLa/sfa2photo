import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<AuthEntity?> execute(AuthEntity entity) async {
    final authEntity = await repository.authenticate(entity);
    if (authEntity != null) {
      await repository.saveCredentials(authEntity);
    }
    return authEntity;
  }
}
