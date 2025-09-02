// application/login_usecase.dart
import '../../data/remote/api_service.dart';
import '../local_cache.dart';
import '../../domain/user.dart';
// import 'dart:convert';

class LoginUseCase {
  final ApiService api; // APIサービス(リモート.ログイン等)
  final LocalCache cache; // ローカルキャッシュ

  //LoginUseCase(this.api, this.cache);

  //Future<User?> login(String userId, String password) async {
  //  final result = await api.login(userId, password);

  //  if (result['success']) {
  //final data = jsonDecode(result['data']);
  //final LocalCache cache; // ローカルキャッシュ

  LoginUseCase(this.api, this.cache);
  //LoginUseCase(this.api);

  Future<User?> login(String userId, String password) async {
    final result = await api.login(userId, password);

    if (result['success']) {
      //final data = jsonDecode(result['data']);
      final data = result['data'] as Map<String, dynamic>; //成功するとMapで返却される想定

      final user = User(
        id: data['id'] ?? 'unknown',
        name: data['name'] ?? 'unknown',
        //email: "dummy@example.com",
        //city: "Tokyo",
      );

      await cache.saveUser(user);
      return user;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchData() async {
    final result = await api.fetchData();
    if (result['success']) {
      //return jsonDecode(result['data']);
      return result['data'] as Map<String, dynamic>;
    }
    return null;
  }

  Future<User?> loadCachedUser() async => await cache.loadUser();

  Future<void> logout() async => await cache.clearUser();
}
