import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
// import '../state/auth_state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStatusProvider);
    final authController = ref.read(authControllerProvider);

    // final authStatus = ref.watch(authStatusProvider);

    // final login = ref.read(authControllerProvider);
    final _userController = TextEditingController();
    final _passController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            Text("Status: $authStatus"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await authController(
                  _userController.text,
                  _passController.text,
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
