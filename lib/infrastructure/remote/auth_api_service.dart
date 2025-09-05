// infrastructure/api_service.dart
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/*
class AuthApiService {
  final String baseUrl;

  late Dio _dio;
  late CookieJar _cookieJar;

  authenticate({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar)); // ★Cookie自動管理
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  //グループウエアのログイン
  Future<Map<String, dynamic>> login(String userId, String password) async {
    try {
      // Step 1: ログイン
      await _dio.post(
        '',
        data: {'user_id': userId, 'password': password, 'login_form': '2'},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status < 400, //ログインが成功すると302リダイレクト
        ),
      );

      // Cookieからmember_idを抽出 ログインが成功していればCookieに含まれる
      final cookies = await _cookieJar.loadForRequest(Uri.parse(baseUrl));
      final memberCookie = cookies.firstWhere(
        (c) => c.name == 'member_id',
        orElse: () => Cookie('', ''),
      );
      if (memberCookie.name.isEmpty)
        throw Exception("member_idがCookieに含まれていません");

      debugPrint("member_id: ${memberCookie.value}");

      //final memberId = memberCookie.value;
      return {
        "success": true,
        "data": {"id": memberCookie.value, "name": "test"},
      };
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchData() async {
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString();
    DateTime now = DateTime.now(); // 現在日時
    String schedule_date_from = DateFormat('yyyy/MM/dd').format(now);

    try {
      // Step 2: スケジュール取得
      final pageRes = await _dio.post(
        '?module=office&controller=schedule&exec=get-graph-data&time=$timestamp',
        data: {
          '_search_pattern': 'month',
          'schedule_date_from': schedule_date_from,
          'schedule_mode': 'member',
          //'_search_org_id': orgId,
          'schedule_member_id': '74',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return {
        "success": true,
        "data": pageRes.data,
      }; // ここは既に Map<String, dynamic>
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }

  Future<void> logout() async {
    await _cookieJar.deleteAll(); // ★Cookie破棄
  }
}

*/
