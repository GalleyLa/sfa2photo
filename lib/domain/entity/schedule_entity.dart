// lib/domain/entity/schedule_entity.dart
class ScheduleEntity {
  final String mode; // "schedule" or "report"
  final String memberId; // 担当者ID
  final String id; // スケジュールID
  final String mouseTitle; // マウスオーバー用タイトル
  final DateTime startDate; // 開始日
  final DateTime endDate; // 終了日
  final String aplResourceDataKey; // 表示用タイトル

  ScheduleEntity({
    required this.mode,
    required this.memberId,
    required this.id,
    required this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.aplResourceDataKey,
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
  };
}
