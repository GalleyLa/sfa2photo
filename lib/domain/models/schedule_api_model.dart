// lib/infrastructure/models/user_model.dart

import '../../domain/entity/schedule_entity.dart';
import '../../shared/utils/date_parser.dart';

class ScheduleApiModel {
  final String mode;
  final String member_id;
  final String id;
  final String mouse_title;
  final String start;
  final String end;
  final String schedule_date;
  final bool allDay;
  final String apl_resource_data_key;

  ScheduleApiModel({
    required this.mode,
    required this.member_id,
    required this.id,
    required this.mouse_title,
    required this.start,
    required this.end,
    required this.schedule_date,
    required this.allDay,
    required this.apl_resource_data_key,
  });

  // DB → Model
  factory ScheduleApiModel.fromMap(Map<String, dynamic> map) {
    //print("API all_day raw = ${map['allDay']} (${map['allDay']?.runtimeType})");
    return ScheduleApiModel(
      mode: map['mode'] as String,
      member_id: map['member_id']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      mouse_title: map['mouse_title'] as String,
      start: map['start'] as String,
      end: map['end'] as String,
      schedule_date: map['schedule_date'] as String,
      allDay: (map['allDay'] is int
          ? map['allDay'] == 1
          : map['allDay'] as bool? ?? false),
      apl_resource_data_key: map['apl_resource_data_key']?.toString() ?? '',
    );
  }

  ScheduleEntity toEntity() {
    final startDate = parseFlexibleDate(start);
    if (startDate == null) throw FormatException("Invalid start date: $start");

    final endDate = parseFlexibleDate(end);
    if (endDate == null) throw FormatException("Invalid end date: $end");

    final scheduleDate = parseFlexibleDate(schedule_date);
    if (scheduleDate == null)
      throw FormatException("Invalid schedule date: $schedule_date");
    //print("Entity allDay(row) = $allDay");
    //print("Entity allDay(int) = ${allDay ? 1 : 0}");
    return ScheduleEntity(
      id: int.parse(id),
      mode: mode,
      memberId: member_id,
      scheduleId: id,
      mouseTitle: mouse_title,
      startDate: startDate,
      endDate: endDate,
      scheduleDate: scheduleDate,
      allDay: allDay ? 1 : 0,
      aplResourceDataKey: apl_resource_data_key,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
    );
  }
}
