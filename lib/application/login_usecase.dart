// application/login_usecase.dart
import '../infrastructure/api_service.dart';
import '../infrastructure/local_cache.dart';
import '../domain/user.dart';

class LoginUseCase {
  final ApiService api;
  final LocalCache cache;

  LoginUseCase(this.api, this.cache);

  Future<User?> login(String userId, String password) async {
    final result = await api.loginAndFetch(userId, password);

    if (result['success']) {
      final data = result['data'];

      // User モデルへ変換（ここはAPI仕様に合わせる）
      final user = User(
        id: data['data']['data']['search_member_ids'] ?? 'unknown',
        name: data['data']['data']['disp_member_name'] ?? 'unknown',
        email: "dummy@example.com",
        city: "Tokyo",
      );

      // キャッシュ保存
      await cache.saveUser(user);
      return user;
    } else {
      return null;
    }
  }

  Future<User?> loadCachedUser() async {
    return await cache.loadUser();
  }

  Future<void> logout() async {
    await cache.clearUser();
  }
}
