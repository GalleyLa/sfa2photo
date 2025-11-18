// lib/domain/entity/schedule_entity.dart
//import '../../infrastructure/local/db/tables/image_table.dart';

class ImageEntity {
  final int id;
  final String scheduleId; // スケジュールID
  final String imagePath; // ファイルパス
  final DateTime scheduleSelDate; // 選択日
  final DateTime? createdAt; // 作成日

  ImageEntity({
    required this.id,
    required this.scheduleId,
    required this.imagePath,
    required this.scheduleSelDate,
    this.createdAt,
  });
}
