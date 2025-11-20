// lib/infrastructure/models/user_model.dart
import '../../domain/entity/schedule_entity.dart';
//import '../../infrastructure/local/db/tables/schedule_table.dart';
import '../../infrastructure/local/db/tables/schedule_table.dart';

class ScheduleDbModel {
  final int id;
  final String mode;
  final String memberId;
  final String scheduleId;
  final String mouseTitle;
  final String startDate;
  final String endDate;
  final String scheduleDate;
  final int allDay;
  final String aplResourceDataKey;
  final String createdAt; // 作成日
  final String updatedAt; // 更新日
  final String deletedAt; // 削除日。未削除ならNULL

  ScheduleDbModel({
    required this.id,
    required this.mode,
    required this.memberId,
    required this.scheduleId,
    required this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.scheduleDate,
    required this.allDay,
    required this.aplResourceDataKey,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  // DB → Model
  factory ScheduleDbModel.fromMap(Map<String, dynamic> map) {
    return ScheduleDbModel(
      id: map[ScheduleTable.id] ?? 0,
      mode: map[ScheduleTable.mode] as String,
      memberId: map[ScheduleTable.memberId] as String,
      scheduleId: map[ScheduleTable.scheduleId] as String,
      mouseTitle: map[ScheduleTable.mouseTitle] as String,
      startDate: map[ScheduleTable.startDate] as String,
      endDate: map[ScheduleTable.endDate] as String,
      scheduleDate: map[ScheduleTable.scheduleDate] as String,
      allDay: map[ScheduleTable.allDay] as int,
      aplResourceDataKey: map[ScheduleTable.aplResourceDataKey] as String,
      createdAt: map[ScheduleTable.createdAt] as String,
      updatedAt: map[ScheduleTable.updatedAt] as String,
      deletedAt: map[ScheduleTable.deletedAt] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //ScheduleTable.id: id,
      ScheduleTable.mode: mode,
      ScheduleTable.memberId: memberId ?? '',
      ScheduleTable.scheduleId: scheduleId ?? '',
      ScheduleTable.mouseTitle: mouseTitle ?? '',
      ScheduleTable.startDate: startDate,
      ScheduleTable.endDate: endDate,
      ScheduleTable.scheduleDate: scheduleDate,
      ScheduleTable.allDay: allDay,
      ScheduleTable.aplResourceDataKey: aplResourceDataKey ?? '',
      ScheduleTable.createdAt: createdAt ?? '',
      ScheduleTable.updatedAt: updatedAt ?? '',
      ScheduleTable.deletedAt: deletedAt,
    };
  }

  ScheduleEntity toEntity() {
    return ScheduleEntity(
      id: id,
      mode: mode,
      memberId: memberId ?? '',
      scheduleId: scheduleId ?? '',
      mouseTitle: mouseTitle ?? '',
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      scheduleDate: DateTime.parse(scheduleDate),
      allDay: allDay,
      aplResourceDataKey: aplResourceDataKey ?? '',
      createdAt: createdAt.isNotEmpty ? DateTime.parse(createdAt) : null,
      updatedAt: updatedAt.isNotEmpty ? DateTime.parse(updatedAt) : null,
      deletedAt: deletedAt.isNotEmpty ? DateTime.parse(deletedAt) : null,
    );
  }

  static ScheduleDbModel fromEntity(ScheduleEntity entity) {
    return ScheduleDbModel(
      id: entity.id,
      mode: entity.mode,
      memberId: entity.memberId ?? '',
      scheduleId: entity.scheduleId ?? '',
      mouseTitle: entity.mouseTitle ?? '',
      startDate: entity.startDate.toIso8601String(),
      endDate: entity.endDate.toIso8601String(),
      scheduleDate: entity.scheduleDate.toIso8601String(),
      allDay: entity.allDay,
      aplResourceDataKey: entity.aplResourceDataKey ?? '',
      createdAt: entity.createdAt?.toIso8601String() ?? '',
      updatedAt: entity.updatedAt?.toIso8601String() ?? '',
      deletedAt: entity.deletedAt?.toIso8601String() ?? '',
    );
  }
}
