import 'base_api_service.dart';

class UserApiService {
  final BaseApiService baseApiService;

  UserApiService(this.baseApiService);

  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await baseApiService.get('/user/profile');
    return response.data;
  }
}
