// lib/infrastructure/schedule_repository_impl.dart

import '../../../domain/entity/schedule_entity.dart';
import '../../../domain/repository/schedule_repository.dart';
import '../service/schedule_api_service.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService apiService;

  ScheduleRepositoryImpl({required this.apiService});

  @override
  Future<List<ScheduleEntity>> fetchRemote() async {
    final result = await apiService.fetchSchedules('74'); // tenantId は仮

    if (result['success'] == true) {
      final List<dynamic> jsonList = result['data'];
      return jsonList
          .map((e) => ScheduleEntity.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch schedules: ${result['data']}');
    }
  }

  @override
  Future<void> saveLocal(List<ScheduleEntity> schedules) async {
    // TODO: Implement local save logic or throw UnimplementedError if not supported
    throw UnimplementedError('saveLocal is not implemented');
  }

  @override
  Future<List<ScheduleEntity>> loadLocal() async {
    // TODO: Implement local load logic or throw UnimplementedError if not supported
    throw UnimplementedError('loadLocal is not implemented');
  }

  @override
  Future<List<ScheduleEntity>> getAllCustomers() async {
    // TODO: Implement getAllCustomers logic or throw UnimplementedError if not supported
    throw UnimplementedError('getAllCustomers is not implemented');
  }
}
