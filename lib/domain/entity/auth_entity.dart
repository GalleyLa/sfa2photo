// lib/domain/entity/auth_entity.dart
class AuthEntity {
  final String username;
  final String password;
  final String? id; // 認証成功後に得られる
  final String? name; // 認証成功後に得られる
  // final List<String>? cookies; // Cookieを文字列で保持

  AuthEntity({
    required this.username,
    required this.password,
    this.id,
    this.name,
    // this.cookies,
  });

  AuthEntity copyWith({String? id, String? name, List<String>? cookies}) {
    return AuthEntity(
      username: username,
      password: password,
      id: id ?? this.id,
      name: name ?? this.name,
      // cookies: cookies ?? this.cookies,
    );
  }
}
