import 'package:dio/dio.dart';
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

    final qp = {'id': userId, ...?queryParameters};

    return await authApiService.dio.get<T>(path, queryParameters: qp);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final userId = await secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("未ログイン状態です");

    final qp = {'id': userId, ...?queryParameters};

    return await authApiService.dio.post<T>(
      path,
      data: data,
      queryParameters: qp,
    );
  }
}
