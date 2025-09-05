// ui/login_page.dart
/*
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../application/usecases/login_usecase.dart';
import '../../infrastructure/remote/auth_api_service.dart';
import '../../infrastructure/local_cache.dart';
import '../../domain/entities/user.dart';

// presentation/screens/login_screen.dart
//import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../viewmodels/login_viewmodel.dart';
//import '../viewmodels/providers.dart';

/*
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(loginViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          Text("保存済みパスワード: ${password ?? "なし"}"),
          ElevatedButton(
            onPressed: () {
              ref.read(loginViewModelProvider.notifier).loadPassword();
            },
            child: const Text("パスワードを読み込む"),
          ),
        ],
      ),
    );
  }
}
*/

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

  late LoginUseCase _useCase; //infrastructure/usecases/login_usecase.dart
  User? _cachedUser;

  @override
  void initState() {
    super.initState();
    final api = ApiService(baseUrl: baseurl);
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

  //TODO: ログイン後のcookieが有る場合は、ログイン不要処理を実装
  void _doLogin() async {
    final userId = _userController.text;
    final password = _passController.text;
    User? user = await _useCase.login(
      userId,
      password,
    ); //application/usecases/login_usecase.dart

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

  // ui/login_page.dart
  void _fetchData() async {
    final data = await _useCase.fetchData();
    setState(() {
      result = data != null ? "データ取得成功: $data" : "データ取得失敗";
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
            if (_cachedUser != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _fetchData, child: const Text("データ取得")),
            ],
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}

*/
