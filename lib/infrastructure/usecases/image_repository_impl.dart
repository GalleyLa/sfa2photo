// lib/infrastructure/schedule_repository_impl.dart
import '../../../domain/entity/image_entity.dart';
import '../../../domain/repository/image_repository.dart';
import '../local/datasources/image_local_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageLocalDatasource localDb;

  ImageRepositoryImpl({required this.localDb});

  @override
  Future<void> saveImage(ImageEntity image) async {
    await localDb.insertImage(image);
  }

  @override
  Future<List<ImageEntity>> getImagesByScheduleId(String scheduleId) async {
    return await localDb.getImagesByScheduleId(scheduleId);
  }

  @override
  Future<List<ImageEntity>> getAllImages() async {
    // TODO: Implement getAllImages logic or throw UnimplementedError if not supported
    throw UnimplementedError('getAllCustomers is not implemented');
    //    return await localDb.getAllImages();
  }
}
