// main.dart
// エントリーポイント
//TODO: hiveからsecure_storageに変更
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'presentation/pages/login_page.dart';

import 'di/locator.dart';
import 'presentation/login_page.dart';

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .envファイルを読み込む
  await dotenv.load(fileName: 'assets/.env');
  // Hive初期化
  await Hive.initFlutter();

  //runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ← デバッグバナー非表示（任意）
      title: 'Get wawa data',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), //presentation/pages/login_page.dart
      //home: const LoginScreen(), //presentation/pages/login_page.dart
    );
  }
}
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 読み込み
  await dotenv.load(fileName: "assets/.env");

  // DI初期化
  final baseUrl = dotenv.env['API_BASE_URL']!;
  setupLocator(baseUrl: baseUrl);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  }
}
