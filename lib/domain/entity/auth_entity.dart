class AuthEntity {
  final String username;
  final String password;
  final String? id; // 認証成功後に得られる
  final String? name; // 認証成功後に得られる

  AuthEntity({
    required this.username,
    required this.password,
    this.id,
    this.name,
  });

  AuthEntity copyWith({String? id, String? name}) {
    return AuthEntity(
      username: username,
      password: password,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
