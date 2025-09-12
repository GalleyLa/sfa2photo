import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/auth_usecase.dart';
import '../../domain/entity/auth_entity.dart';
import '../state/auth_state.dart';
import '../../di/providers.dart';

/*
本来は AuthRepository で例外を投げる → AuthUseCase で処理 → AuthNotifier で AuthError に変換、
という流れが自然ですが、今回は簡略化してます。
*/

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUseCase _useCase;

  AuthNotifier(this._useCase) : super(AuthState.initial());

  /// ログイン処理
  Future<void> login(String username, String password) async {
    // ローディング開始
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final entity = AuthEntity(username: username, password: password);
    final result = await _useCase.execute(entity);

    if (result != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: "ユーザー名またはパスワードが間違っています",
      );
    }
  }

  /// ログアウト処理
  void logout() {
    state = AuthState.initial().copyWith(status: AuthStatus.unauthenticated);
  }
}

/// AuthNotifier を提供する Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final useCase = ref.watch(authUseCaseProvider);
  return AuthNotifier(useCase);
});
