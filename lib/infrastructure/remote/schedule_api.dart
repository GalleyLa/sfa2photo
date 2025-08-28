// infrastructure/remote/schedule_api.dart
import 'package:dio/dio.dart';
import '../../domain/schedule.dart';

class ScheduleApi {
  final Dio _dio;
  ScheduleApi(this._dio);

  Future<List<Schedule>> fetchSchedules(String memberId) async {
    final response = await _dio.post(
      "/?module=office&controller=schedule&exec=get-graph-data",
      data: {"schedule_member_id": memberId, "schedule_mode": "member"},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = response.data["data"]["result"] as List;
    return data.map((json) => Schedule.fromJson(json)).toList();
  }
}
