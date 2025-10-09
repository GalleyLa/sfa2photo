// lib/infrastructure/models/user_model.dart

//import '../../domain/entity/schedule_entity.dart';

class ScheduleDto {
  final String mode;
  final String member_id;
  final String id;
  final String mouse_title;
  final String start;
  final String end;
  final String apl_resource_data_key;

  ScheduleDto({
    required this.mode,
    required this.member_id,
    required this.id,
    required this.mouse_title,
    required this.start,
    required this.end,
    required this.apl_resource_data_key,
  });

  // DB → Model
  factory ScheduleDto.fromMap(Map<String, dynamic> map) {
    return ScheduleDto(
      mode: map['mode'] as String,
      member_id: map['member_id'] as String,
      id: map['id'] as String,
      mouse_title: map['mouse_title'] as String,
      start: map['start'] as String,
      end: map['end'] as String,
      apl_resource_data_key: map['apl_resource_data_key'] as String,
    );
  }
}
