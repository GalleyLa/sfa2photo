import 'base_api_service.dart';

class ProjectApiService {
  final BaseApiService baseApiService;

  ProjectApiService(this.baseApiService);

  Future<Map<String, dynamic>> fetchProjects(String tenantId) async {
    final response = await baseApiService.get(
      '/project/list',
      queryParameters: {
        'tenant_id': tenantId, // 呼び出し時に追加
      },
    );
    return response.data;
  }
}
