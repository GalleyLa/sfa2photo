// lib/domain/repository/schedule_repository.dart
import '../entity/image_entity.dart';

abstract class ImageRepository {
  //Future<List<ImageEntity>> fetchRemote();
  //Future<void> saveLocal(List<ImageEntity> images);
  //Future<List<ImageEntity>> loadLocal();
  Future<void> saveImage(ImageEntity image);
  Future<List<ImageEntity>> getImagesByScheduleId(String scheduleId);
  //Future<List<ImageEntity>> fetchImages();
  Future<List<ImageEntity>> loadAllImages();
}
