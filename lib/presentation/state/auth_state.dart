import '../../domain/entity/auth_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

enum AuthError { invalidCredentials, networkError, unknown }

class AuthState {
  final AuthStatus status;
  final AuthEntity? user;
  final AuthError? error;

  const AuthState({required this.status, this.user, this.error});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthStatus? status, AuthEntity? user, AuthError? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error, // null を渡せばリセットされる
    );
  }
}
