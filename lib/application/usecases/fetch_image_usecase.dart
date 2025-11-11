import '../../domain/entity/image_entity.dart';
import '../../domain/repository/image_repository.dart';

class FetchImagesUseCase {
  final ImageRepository repository;

  FetchImagesUseCase(this.repository);

  Future<List<ImageEntity>> execute() async {
    return await repository.loadAllImages();
  }
}
