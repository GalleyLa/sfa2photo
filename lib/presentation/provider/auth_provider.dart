import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/auth_usecase.dart';
import '../../domain/entities/auth_entity.dart';
import '../state/auth_state.dart';
import '../../di/locator.dart';

final authStatusProvider = StateProvider<AuthStatus>(
  (ref) => AuthStatus.initial,
);

final authUseCaseProvider = Provider<AuthUseCase>(
  (ref) => getIt<AuthUseCase>(),
);

final authControllerProvider = Provider((ref) {
  final useCase = ref.watch(authUseCaseProvider);
  final authStatus = ref.read(authStatusProvider.notifier);

  return (String username, String password) async {
    final entity = AuthEntity(username: username, password: password);
    final success = await useCase.execute(entity);
    authStatus.state = success
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  };
});
