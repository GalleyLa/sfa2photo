import '../../domain/entity/image_entity.dart';
import '../../infrastructure/local/db/tables/image_table.dart';

class ImageDbModel {
  final int id;
  final String scheduleId; // スケジュールID
  final String imagePath; // マウスオーバー用タイトル
  final DateTime scheduleSelDate;
  final DateTime? createdAt; // 作成日

  ImageDbModel({
    required this.id,
    required this.scheduleId,
    required this.imagePath,
    required this.scheduleSelDate,
    this.createdAt,
  });

  factory ImageDbModel.fromMap(Map<String, dynamic> map) {
    return ImageDbModel(
      id: map[ImageTable.id] ?? 0,
      scheduleId: map[ImageTable.scheduleId]?.toString() ?? '',
      imagePath: map[ImageTable.imagePath]?.toString() ?? '',
      scheduleSelDate:
          DateTime.tryParse(map[ImageTable.scheduleSelDate] ?? '') ??
          DateTime.now(),
      createdAt: DateTime.tryParse(map[ImageTable.createdAt] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ImageTable.scheduleId: scheduleId,
      ImageTable.imagePath: imagePath,
      ImageTable.scheduleSelDate: scheduleSelDate.toIso8601String(),
      ImageTable.createdAt: createdAt?.toIso8601String(),
    };
  }

  ImageEntity toEntity() {
    return ImageEntity(
      id: id,
      scheduleId: scheduleId,
      imagePath: imagePath,
      scheduleSelDate: scheduleSelDate,
      createdAt: createdAt,
    );
  }

  static ImageDbModel fromEntity(ImageEntity entity) {
    return ImageDbModel(
      id: entity.id,
      scheduleId: entity.scheduleId,
      imagePath: entity.imagePath,
      scheduleSelDate: entity.scheduleSelDate,
      createdAt: entity.createdAt,
    );
  }
}
