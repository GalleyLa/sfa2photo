import '../../domain/entity/auth_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

enum AuthError { invalidCredentials, networkError, unknown }

class AuthState {
  final AuthStatus status;
  final AuthEntity? user;
  final String? errorMessage; // 追加！

  const AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage, // null を渡せばリセットされる
    );
  }
}
