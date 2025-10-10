// lib/domain/entity/schedule_entity.dart
class ScheduleEntity {
  final String mode; // "schedule" or "report"
  final String memberId; // 担当者ID
  final String id; // スケジュールID
  final String mouseTitle; // マウスオーバー用タイトル
  final DateTime startDate; // 開始日
  final DateTime endDate; // 終了日
  final String aplResourceDataKey; // 表示用タイトル
  final DateTime createdAt; // 作成日
  final DateTime updatedAt; // 更新日
  final DateTime? deletedAt; // 削除日。未削除ならNULL

  ScheduleEntity({
    required this.mode,
    required this.memberId,
    required this.id,
    required this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.aplResourceDataKey,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    return ScheduleEntity(
      mode: map['mode'] as String,
      memberId: map['memberId'] as String,
      id: map['id'] as String,
      mouseTitle: map['mouseTitle'] as String,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      aplResourceDataKey: map['aplResourceDataKey'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'mode': mode,
    'memberId': memberId,
    'id': id,
    'mouseTitle': mouseTitle,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'aplResourceDataKey': aplResourceDataKey,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
  };
}
