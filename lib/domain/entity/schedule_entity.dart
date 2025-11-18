// lib/domain/entity/schedule_entity.dart
//import '../../infrastructure/local/db/tables/schedule_table.dart';

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
}
