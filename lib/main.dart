// main.dart
// エントリーポイント
//TODO: hiveからsecure_storageに変更
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'di/providers.dart';
import 'presentation/pages/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

//import 'package:dcdg/dcdg.dart'; //クラス図作成ツール用
//flutter pub global run dcdgで表示される値をPlantUML Editorにコピペしてクラス図を生成できる

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // ウィジェットツリー全体の初期化や管理

  // .env 読み込み
  // await dotenv.load(fileName: "assets/.env");
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: 'assets/.env.$env');

  // DI初期化
  // final baseUrl = dotenv.env['API_BASE_URL']!;
  // setupLocator(baseUrl: baseUrl);

  await initializeDateFormatting('ja_JP').then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // これを追加するだけ
      title: 'Auth Demo',
      home: const LoginScreen(),
    );
  }
}
