// ui/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../application/login_usecase.dart';
import '../infrastructure/api_service.dart';
import '../infrastructure/local_cache.dart';
import '../domain/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  String result = "";
  String baseurl = dotenv.get('BASE_URL');

  late LoginUseCase _useCase;
  User? _cachedUser;

  @override
  void initState() {
    super.initState();
    final api = ApiService(baseUrl: baseurl, orgId: "2818");
    final cache = LocalCache();
    _useCase = LoginUseCase(api, cache);

    _loadCachedUser();
  }

  void _loadCachedUser() async {
    final user = await _useCase.loadCachedUser();
    setState(() {
      _cachedUser = user;
      result = user != null ? "前回のログイン: ${user.name}" : "キャッシュなし";
    });
  }

  void _doLogin() async {
    final userId = _userController.text;
    final password = _passController.text;
    User? user = await _useCase.login(userId, password);

    setState(() {
      result = user != null ? "ログイン成功: ${user.name}" : "ログイン失敗";
      _cachedUser = user;
    });
  }

  void _logout() async {
    await _useCase.logout();
    setState(() {
      _cachedUser = null;
      result = "ログアウトしました";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン画面")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: "ユーザーID"),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: "パスワード"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _doLogin, child: const Text("ログイン")),
            ElevatedButton(onPressed: _logout, child: const Text("ログアウト")),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
