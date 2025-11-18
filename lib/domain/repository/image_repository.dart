// lib/domain/repository/schedule_repository.dart
import '../entity/image_entity.dart';

abstract class ImageRepository {
  Future<void> saveImage(ImageEntity image);
  Future<List<ImageEntity>> getImagesByScheduleId(String scheduleId);
  Future<List<ImageEntity>> loadAllImages();
}
