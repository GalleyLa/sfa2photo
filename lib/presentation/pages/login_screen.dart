import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import 'home_screen.dart';
import '../state/auth_state.dart';

// If AuthStatus is defined in auth_provider.dart, ensure it is exported there.
// Otherwise, define it here or import from the correct file.

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // 認証成功で遷移
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
      if (next.error != null) {
        String message;
        switch (next.error!) {
          case AuthError.invalidCredentials:
            message = "ユーザー名またはパスワードが間違っています";
            break;
          case AuthError.networkError:
            message = "ネットワークエラーが発生しました。接続を確認してください";
            break;
          case AuthError.unknown:
          default:
            message = "不明なエラーが発生しました";
            break;
        }
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("ログインエラー"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        leadingWidth: 85, //leadingWidthを設定する
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: ${authState.status}"),
            const SizedBox(height: 16),

            // ユーザー名入力欄
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // パスワード入力欄
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            if (authState.status == AuthStatus.loading) ...[
              const CircularProgressIndicator(),
            ] else ...[
              // ログインボタン
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ユーザー名とパスワードを入力してください")),
                    );
                    return;
                  }

                  await ref
                      .read(
                        authNotifierProvider.notifier,
                      ) // AuthNotifierProviderのnotifierを取得
                      .login(
                        username,
                        password,
                      ); // auth_provider loginメソッドを呼び出し
                },
                child: const Text("Login"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
