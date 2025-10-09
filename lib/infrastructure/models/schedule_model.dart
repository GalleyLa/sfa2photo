// lib/infrastructure/models/user_model.dart

import '../local/db/tables/schedule_table.dart';

class ScheduleModel {
  final String mode;
  final String memberId;
  final String id;
  final String mouseTitle;
  final String startDate;
  final String endDate;
  final String aplResourceDataKey;
  final String createdAt; // 作成日
  final String updatedAt; // 更新日
  final String deletedAt; // 削除日。未削除ならNULL

  ScheduleModel({
    required this.mode,
    required this.memberId,
    required this.id,
    required this.mouseTitle,
    required this.startDate,
    required this.endDate,
    required this.aplResourceDataKey,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  // DB → Model
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      mode: map['mode'] as String,
      memberId: map['member_id'] as String,
      id: map['id'] as String,
      mouseTitle: map['mouse_title'] as String,
      startDate: map['start'] as String,
      endDate: map['end'] as String,
      aplResourceDataKey: map['apl_resource_data_key'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      deletedAt: map['deleted_at'] as String,
    );
  }
}
