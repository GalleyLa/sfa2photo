// presentation/viewmodels/login_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/usecases/get_password_usecase.dart';
import '/domain/usecases/save_password_usecase.dart';
import '/domain/entities/password.dart';

class LoginViewModel extends StateNotifier<String?> {
  final SavePasswordUseCase savePasswordUseCase;
  final GetPasswordUseCase getPasswordUseCase;

  LoginViewModel(this.savePasswordUseCase, this.getPasswordUseCase)
    : super(null);

  Future<void> savePassword(String password) async {
    await savePasswordUseCase(password);
    state = password;
  }

  Future<void> loadPassword() async {
    final Password? password = await getPasswordUseCase();
    state = password?.value; // ← SecureStorage の値がここに反映される
  }
}
