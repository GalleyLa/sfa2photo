import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/auth_provider.dart';
import 'state/auth_state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final authStatus = ref.watch(authStatusProvider);

    final login = ref.read(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'ユーザ名'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  login(usernameController.text, passwordController.text),
              child: const Text('ログイン'),
            ),
            const SizedBox(height: 16),
            Text(switch (authStatus) {
              AuthStatus.initial => '未認証',
              AuthStatus.authenticated => 'ログイン成功',
              AuthStatus.unauthenticated => 'ログイン失敗',
            }),
          ],
        ),
      ),
    );
  }
}
