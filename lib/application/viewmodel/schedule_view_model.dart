import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dart:io';
import '../usecases/save_image_usecase.dart';
import '../../domain/entity/image_entity.dart';
//import '../../shared/utils/date_formatter_provider.dart';
import '../../shared/utils/date_formatter.dart';

class ScheduleViewModel extends AsyncNotifier<void> {
  late final SaveImageUseCase _saveImageUseCase;

  @override
  Future<void> build() async {
    // 初期化処理なしの場合は空でOK
  }

  void init(SaveImageUseCase useCase) {
    _saveImageUseCase = useCase;
  }

  /// スケジュールタップ → カメラ起動 → 画像保存処理
  Future<void> captureAndSaveImage(String scheduleId) async {
    try {
      state = const AsyncLoading();

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        state = const AsyncData(null);
        return; // ユーザーがキャンセル
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
        //createdAt: DateFormatter.nowString(),
      );

      // DBに保存
      await _saveImageUseCase.execute(entity);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
