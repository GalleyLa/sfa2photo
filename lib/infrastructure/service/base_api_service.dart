// lib/infrastructure/service/base_api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_api_service.dart';

class BaseApiService {
  final AuthApiService authApiService;
  final FlutterSecureStorage secureStorage;

  BaseApiService(this.authApiService, this.secureStorage);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final userId = await secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("未ログイン状態です");
    // 必須の id を付与
    final qp = {'id': userId, ...?queryParameters}; // 呼び出し元から追加パラメータ

    return await authApiService.dio.get<T>(path, queryParameters: qp);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final userId = await secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("未ログイン状態です");

    final qp = {...?queryParameters};

    final cookies = await authApiService.cookieJar.loadForRequest(
      //Uri.parse(authApiService.dio.options.baseUrl),
      Uri.parse("http://172.30.100.160/oec/"),
    );
    debugPrint("BaseApiServiceから見えるCookie: $cookies");

    return await authApiService.dio.post<T>(
      path,
      data: data,
      queryParameters: qp,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }
}
