import '../../domain/entity/image_entity.dart';
import '../../domain/repository/image_repository.dart';

class DeleteImageUseCase {
  final ImageRepository repository;

  DeleteImageUseCase(this.repository);

  Future<void> execute(ImageEntity image) async {
    //await repository.deleteImage(image);
  }
}
