// lib/domain/usecase/save_image_usecase.dart
import '../../domain/entity/image_entity.dart';
//import '../../domain/repository/image_repository.dart';

class GroupImagesByDayUseCase {
  /// 日付（yyyy-MM-dd で丸めた DateTime）をキーにした Map を返す
  Map<DateTime, List<ImageEntity>> execute(List<ImageEntity> images) {
    final map = <DateTime, List<ImageEntity>>{};

    for (final img in images) {
      // 時間情報を切り捨てて日付だけにまとめる
      final date = DateTime(
        //img.createdAt!.year,
        //img.createdAt!.month,
        //img.createdAt!.day,
        img.scheduleSelDate.year,
        img.scheduleSelDate.month,
        img.scheduleSelDate.day,
      );

      map.putIfAbsent(date, () => []).add(img);
    }

    return map;
  }
}
