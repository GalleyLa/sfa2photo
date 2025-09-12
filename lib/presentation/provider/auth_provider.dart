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

  Future<void> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final entity = AuthEntity(username: username, password: password);
      final result = await _useCase.execute(entity);

      if (result != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: AuthError.invalidCredentials,
        );
      }
    } on Exception catch (e) {
      // 簡易的に判定（本来は DioException 等を詳細に判別）
      if (e.toString().contains("Network")) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: AuthError.networkError,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: AuthError.unknown,
        );
      }
    }
  }

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
