// lib/domain/usecase/save_image_usecase.dart
import '../../domain/entity/image_entity.dart';
import '../../domain/repository/image_repository.dart';

class SaveImageUseCase {
  final ImageRepository repository;

  SaveImageUseCase(this.repository);

  Future<void> execute(ImageEntity image) async {
    await repository.saveImage(image);
  }
}
