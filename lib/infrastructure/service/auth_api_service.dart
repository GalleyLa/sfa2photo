//  lib/infrastructure/service/auth_api_service.dart

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
//import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
//import 'dart:io';

class AuthApiService {
  final String baseUrl;
  late Dio _dio;
  late CookieJar cookieJar;
  /*
  AuthApiService(this.baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar)); // Cookie自動管理
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
  */
  AuthApiService(this.baseUrl)
    : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
      cookieJar = CookieJar() {
    _dio.interceptors.add(CookieManager(cookieJar));
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Dio get dio => _dio; // 他APIサービスで再利用するために公開

  // Future<String> authenticate(String username, String password) async {
  //   // 既存の認証API呼び出しに差し替え
  //   throw UnimplementedError();
  Future<Map<String, dynamic>> login(String userId, String password) async {
    try {
      await _dio.post(
        '',
        data: {'user_id': userId, 'password': password, 'login_form': '2'},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status < 400, // 302リダイレクトも成功扱い
        ),
      );

      final cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
      final memberCookie = cookies.firstWhere(
        (c) => c.name == 'member_id',
        orElse: () => Cookie('', ''),
      );
      if (memberCookie.name.isEmpty) {
        throw Exception("member_idがCookieに含まれていません");
      }

      final debugcookies = await cookieJar.loadForRequest(
        Uri.parse("http://172.30.100.160/oec/"),
      );
      debugPrint("保存されたCookie: $debugcookies");
      debugPrint("member_id: ${memberCookie.value}");

      // Cookieを文字列リストとして返却
      // final cookieStrings = cookies.map((c) => "${c.name}=${c.value}").toList();

      return {
        "success": true,
        "data": {"id": memberCookie.value, "name": "test"},
        // "cookies": cookieStrings,
      };
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }
}
