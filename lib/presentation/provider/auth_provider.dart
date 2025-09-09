// lib/presentation/provider/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/auth_usecase.dart';
import '../../domain/entity/auth_entity.dart';
import '../state/auth_state.dart';
import '../../di/providers.dart';

/// 認証状態
final authStatusProvider = StateProvider<AuthStatus>(
  (ref) => AuthStatus.initial,
);

/// ログイン後の AuthEntity を保持
final authEntityProvider = StateProvider<AuthEntity?>((ref) => null);

/// AuthController Provider
final authControllerProvider = Provider((ref) {
  final useCase = ref.watch(authUseCaseProvider);
  final authStatus = ref.read(authStatusProvider.notifier);
  final authEntity = ref.read(authEntityProvider.notifier);

  /// コントローラ関数
  return (String username, String password) async {
    final entity = AuthEntity(username: username, password: password);
    final result = await useCase.execute(entity);

    if (result != null) {
      authEntity.state = result;
      authStatus.state = AuthStatus.authenticated;
    } else {
      authEntity.state = null;
      authStatus.state = AuthStatus.unauthenticated;
    }
  };
});
