import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import '../state/auth_state.dart'; // Ensure this file defines AuthStatus
import 'login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authEntity = ref.watch(authEntityProvider);
    final authStatus = ref.watch(authStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, ${authEntity?.username ?? 'Guest'}"),
            const SizedBox(height: 16),
            Text("Status: $authStatus"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(authEntityProvider.notifier).state = null;
                ref.read(authStatusProvider.notifier).state =
                    AuthStatus.unauthenticated;
                //Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
