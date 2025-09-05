import 'package:dio/dio.dart';
import '../service/auth_api_service.dart';

class SomeOtherApiService {
  final AuthApiService authApiService;

  SomeOtherApiService(this.authApiService);

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      final response = await authApiService.dio.get(
        '/user/data',
        queryParameters: {'id': userId}, // Cookie + id を送信
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
