// lib/infrastructure/models/user_model.dart

import '../../domain/entity/schedule_entity.dart';

class ScheduleApiModel {
  final String mode;
  final String member_id;
  final String id;
  final String mouse_title;
  final String start;
  final String end;
  final String apl_resource_data_key;

  ScheduleApiModel({
    required this.mode,
    required this.member_id,
    required this.id,
    required this.mouse_title,
    required this.start,
    required this.end,
    required this.apl_resource_data_key,
  });

  // DB → Model
  factory ScheduleApiModel.fromMap(Map<String, dynamic> map) {
    return ScheduleApiModel(
      mode: map['mode'] as String,
      member_id: map['member_id']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      mouse_title: map['mouse_title'] as String,
      start: map['start'] as String,
      end: map['end'] as String,
      apl_resource_data_key: map['apl_resource_data_key']?.toString() ?? '',
    );
  }

  ScheduleEntity toEntity() {
    return ScheduleEntity(
      mode: mode,
      memberId: member_id,
      id: id,
      mouseTitle: mouse_title,
      startDate: DateTime.parse(start),
      endDate: DateTime.parse(end),
      aplResourceDataKey: apl_resource_data_key,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
    );
  }
}
