// domain/usecases/save_password_usecase.dart

import '../entities/password.dart';
import '../repositories/password_repository.dart';

class SavePasswordUseCase {
  final PasswordRepository repository;
  SavePasswordUseCase(this.repository);

  Future<void> call(String password) {
    return repository.savePassword(Password(password));
  }
}
