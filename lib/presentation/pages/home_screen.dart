import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sfa2photo/presentation/widgets/loading_indicator.dart';
import '../provider/auth_provider.dart';
//import '../provider/schedule_providers.dart';
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
      appBar: AppBar(title: const Text("Home")),
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
                // final schedulesState = ref.read(scheduleNotifierProvider);
              },

              child: const Text("スケジュール一覧"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //MaterialPageRoute(builder: (_) => const HomeScreen());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
                // final schedulesState = ref.read(scheduleNotifierProvider);
              },

              child: const Text("カレンダー"),
            ),
          ],
        ),
      ),
    );
  }
}
