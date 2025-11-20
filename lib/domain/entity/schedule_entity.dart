// lib/domain/entity/schedule_entity.dart
//import '../../infrastructure/local/db/tables/schedule_table.dart';

class ScheduleEntity {
  final int id;
  final String mode; // "schedule" or "report"
  final String? memberId; // 担当者ID
  final String scheduleId; // スケジュールID
  final String? mouseTitle; // マウスオーバー用タイトル
  final DateTime startDate; // 開始日
  final DateTime endDate; // 終了日
  final DateTime scheduleDate; // スケジュール日
  final int allDay; // 終日フラグ
  final String? aplResourceDataKey; // 表示用タイトル
  final DateTime? createdAt; // 作成日
  final DateTime? updatedAt; // 更新日
  final DateTime? deletedAt; // 削除日。未削除ならNULL

  ScheduleEntity({
    required this.id,
    required this.mode,
    this.memberId,
    required this.scheduleId,
    this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.scheduleDate,
    required this.aplResourceDataKey,
    required this.allDay,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}
