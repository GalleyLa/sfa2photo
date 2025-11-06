import '../../domain/entity/image_entity.dart';

class ImageDbModel {
  final int id;
  final String scheduleId; // スケジュールID
  final String imagePath; // マウスオーバー用タイトル
  final DateTime? createdAt; // 作成日

  ImageDbModel({
    required this.id,
    required this.scheduleId,
    required this.imagePath,
    this.createdAt,
  });

  factory ImageDbModel.fromMap(Map<String, dynamic> map) {
    return ImageDbModel(
      id: map['id'] ?? 0,
      scheduleId: map['schedule_id']?.toString() ?? '',
      imagePath: map['image_path']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'image_path': imagePath,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ImageEntity toEntity() {
    return ImageEntity(
      id: id,
      scheduleId: scheduleId,
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }

  static ImageDbModel fromEntity(ImageEntity entity) {
    return ImageDbModel(
      id: entity.id,
      scheduleId: entity.scheduleId,
      imagePath: entity.imagePath,
      createdAt: entity.createdAt,
    );
  }
}
