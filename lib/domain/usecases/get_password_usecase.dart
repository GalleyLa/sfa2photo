// domain/usecases/get_password_usecase.dart

import '../entities/password.dart';
import '../repositories/password_repository.dart';

class GetPasswordUseCase {
  final PasswordRepository repository;
  GetPasswordUseCase(this.repository);

  Future<Password?> call() async {
    return await repository.getPassword();
  }
}
