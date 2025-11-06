import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';

import '../provider/schedule_notifier_provider.dart';
import 'login_screen.dart';
import 'schedule_calendar_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final schedulesAsync = ref.watch(scheduleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        leadingWidth: 85, //leadingWidthを設定する
        leading: TextButton(
          child: const Text(
            '〈 戻る',
            style: TextStyle(
              //color: Colors.white, //文字の色を白にする
              fontWeight: FontWeight.bold, //文字を太字する
              fontSize: 18.0, //文字のサイズを調整する
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          //automaticallyImplyLeading: false, // 戻るボタンを非表示にする
          //leading: null, // 完全に戻るボタンを無くす
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, ${authState.user?.username ?? 'Guest'}"),
            const SizedBox(height: 16),
            Text("Status: ${authState.status}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("Logout"),
            ),

            if (schedulesAsync.isLoading == true) ...[
              const CircularProgressIndicator(),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(scheduleNotifierProvider.notifier).fetch();
              },

              child: const Text("スケジュール一覧"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
              },

              child: const Text("カレンダー"),
            ),
          ],
        ),
      ),
    );
  }
}
