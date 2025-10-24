// lib/domain/entity/schedule_entity.dart
import '../../infrastructure/local/db/tables/schedule_table.dart';

class ScheduleEntity {
  final String mode; // "schedule" or "report"
  final String? memberId; // 担当者ID
  final String id; // スケジュールID
  final String? mouseTitle; // マウスオーバー用タイトル
  final DateTime startDate; // 開始日
  final DateTime endDate; // 終了日
  final String? aplResourceDataKey; // 表示用タイトル
  final DateTime? createdAt; // 作成日
  final DateTime? updatedAt; // 更新日
  final DateTime? deletedAt; // 削除日。未削除ならNULL

  ScheduleEntity({
    required this.mode,
    this.memberId,
    required this.id,
    this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.aplResourceDataKey,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    return ScheduleEntity(
      mode: map['mode']?.toString() ?? '',
      memberId: map['member_id']?.toString(),
      id: map['id']?.toString() ?? '',
      mouseTitle: map['mouse_title']?.toString(),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      aplResourceDataKey: map['apl_resource_data_key']?.toString(),
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? ''),
      deletedAt: DateTime.tryParse(map['deleted_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ScheduleTable.id: id,
      ScheduleTable.mode: mode,
      ScheduleTable.memberId: memberId ?? '',
      ScheduleTable.mouseTitle: mouseTitle ?? '',
      ScheduleTable.startDate: startDate.toIso8601String(),
      ScheduleTable.endDate: endDate.toIso8601String(),
      ScheduleTable.aplResourceDataKey: aplResourceDataKey ?? '',
      ScheduleTable.createdAt: createdAt?.toIso8601String() ?? '',
      ScheduleTable.updatedAt: updatedAt?.toIso8601String() ?? '',
      ScheduleTable.deletedAt: deletedAt?.toIso8601String(),
    };
  }
}
