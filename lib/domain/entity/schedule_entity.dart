// lib/domain/entity/schedule_entity.dart
class ScheduleEntity {
  final String mode; // "schedule" or "report"
  final String member_id; // 担当者ID
  final String id; // スケジュールID
  final DateTime start_date; // 開始日
  final DateTime end_date; // 終了日
  final String apl_resource_data_key; // 表示用タイトル
  final String customer_name;
  final String project_name; // 紐づく顧客ID（APIで返るなら）

  ScheduleEntity({
    required this.mode,
    required this.member_id,
    required this.id,
    required this.start_date,
    required this.end_date,
    required this.apl_resource_data_key,
    required this.customer_name,
    required this.project_name,
  });

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    return ScheduleEntity(
      mode: map['mode'] as String,
      member_id: map['member_id'] as String,
      id: map['id'] as String,
      start_date: DateTime.parse(map['start_date']),
      end_date: DateTime.parse(map['end_date']),
      apl_resource_data_key: map['apl_resource_data_key'] as String,
      customer_name: map['customer_name'] as String,
      project_name: map['project_name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'mode': mode,
    'member_id': member_id,
    'id': id,
    'start_date': start_date.toIso8601String(),
    'end_date': end_date.toIso8601String(),
    'apl_resource_data_key': apl_resource_data_key,
    'customer_name': customer_name,
    'project_name': project_name,
  };
}
