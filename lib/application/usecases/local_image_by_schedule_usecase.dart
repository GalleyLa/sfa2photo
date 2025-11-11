import '../../domain/entity/image_entity.dart';
import '../../domain/repository/image_repository.dart';

class LoadImagesByScheduleIdUseCase {
  final ImageRepository repository;
  LoadImagesByScheduleIdUseCase(this.repository);

  Future<List<ImageEntity>> execute(String scheduleId) async {
    return await repository.getImagesByScheduleId(scheduleId);
  }
}
