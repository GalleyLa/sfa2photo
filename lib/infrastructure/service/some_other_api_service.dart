import 'base_api_service.dart';

class SomeOtherApiService {
  final BaseApiService baseApiService;

  SomeOtherApiService(this.baseApiService);

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final response = await baseApiService.get('/user/data');
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profile,
  ) async {
    try {
      final response = await baseApiService.post('/user/update', data: profile);
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
