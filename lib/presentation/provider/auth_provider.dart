import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/auth_usecase.dart';
import '../../domain/entity/auth_entity.dart';
import '../state/auth_state.dart';
import '../../di/locator.dart';

final authStatusProvider = StateProvider<AuthStatus>(
  (ref) => AuthStatus.initial,
);

// ログイン後に利用できる AuthEntity を保持する Provider
final authEntityProvider = StateProvider<AuthEntity?>((ref) => null);

final authUseCaseProvider = Provider<AuthUseCase>(
  (ref) => getIt<AuthUseCase>(),
);

final authControllerProvider = Provider((ref) {
  final useCase = ref.watch(authUseCaseProvider);
  final authStatus = ref.read(authStatusProvider.notifier);
  final authEntity = ref.read(authEntityProvider.notifier);

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
