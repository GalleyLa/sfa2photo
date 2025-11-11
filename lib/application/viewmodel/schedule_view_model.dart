import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entity/image_entity.dart';
import '../usecases/save_image_usecase.dart';
import '../usecases/fetch_image_usecase.dart';
import '../usecases/group_Images_by_date_usecase.dart';
import '../../presentation/provider/common_providers.dart';

class ScheduleViewModel extends AsyncNotifier<void> {
  late final SaveImageUseCase _saveImageUseCase;
  late final FetchImagesUseCase _fetchImagesUseCase;
  final GroupImagesByDayUseCase _groupImagesByDayUseCase =
      GroupImagesByDayUseCase();

  /// 撮影日ごとの写真Map
  Map<DateTime, List<ImageEntity>> photoMap = {};

  /// build() で初期化＋DB読み込み
  @override
  Future<void> build() async {
    // UseCase を注入（FutureProvider 経由）
    _saveImageUseCase = await ref.watch(saveImageUseCaseProvider.future);
    _fetchImagesUseCase = await ref.watch(fetchImagesUseCaseProvider.future);

    // DB から写真を読み込み photoMap を作成
    await _reloadPhotos();
  }

  /// DB から画像を取得して photoMap を更新
  Future<void> _reloadPhotos() async {
    final photos = await _fetchImagesUseCase.execute();
    print('取得した写真枚数: ${photos.length}');

    photoMap = _groupImagesByDayUseCase.execute(photos);
  }

  /// スケジュールタップ → カメラ起動 → 画像保存処理
  /// true: 保存成功, false: キャンセル
  Future<bool> captureAndSaveImage(String scheduleId) async {
    try {
      state = const AsyncLoading();

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        state = const AsyncData(null);
        return false; // ユーザーがキャンセル
      }

      // 保存先（アプリ専用フォルダ）
      final directory = await getApplicationDocumentsDirectory();
      final filename = p.basename(pickedFile.path);
      final savedPath = p.join(directory.path, filename);

      // 画像を保存（コピー）
      final imageFile = File(pickedFile.path);
      await imageFile.copy(savedPath);

      // Entity作成
      final entity = ImageEntity(
        id: 0,
        scheduleId: scheduleId,
        imagePath: savedPath,
        createdAt: DateTime.now(),
      );

      // DBに保存
      await _saveImageUseCase.execute(entity);

      // 撮影後に Map を更新して UI に反映
      await _reloadPhotos();

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
