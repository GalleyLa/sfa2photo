// lib/domain/entity/schedule_entity.dart
import '../../infrastructure/local/db/tables/image_table.dart';

class ImageEntity {
  final int id;
  final String scheduleId; // スケジュールID
  final String imagePath; // マウスオーバー用タイトル
  final DateTime? createdAt; // 作成日

  ImageEntity({
    required this.id,
    required this.scheduleId,
    required this.imagePath,
    this.createdAt,
  });
  /*
  factory ImageEntity.fromMap(Map<String, dynamic> map) {
    return ImageEntity(
      id: map['id'] ?? 0,
      scheduleId: map['schedule_id']?.toString() ?? '',
      imagePath: map['image_path']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ImageTable.scheduleId: scheduleId,
      ImageTable.imagePath: imagePath,
      ImageTable.createdAt: createdAt?.toIso8601String(),
    };
  }
}
*/
}
