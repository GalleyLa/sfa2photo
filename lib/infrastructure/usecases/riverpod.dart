/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/load_data_usecase.dart';
import '../../domain/entity/data_entity.dart';
import '../../di/providers.dart';

final dataProvider = StateProvider<DataEntity?>((ref) => null);

final loadDataUseCaseProvider = Provider<LoadDataUseCase>(
  (ref) => getIt<LoadDataUseCase>(),
);

final dataControllerProvider = Provider((ref) {
  final useCase = ref.watch(loadDataUseCaseProvider);
  final state = ref.read(dataProvider.notifier);

  return () async {
    // 起動時ローカル読み込み
    final localData = await useCase.loadFromLocal();
    if (localData != null) {
      state.state = localData;
    }
  };
});

final syncControllerProvider = Provider((ref) {
  final useCase = ref.watch(loadDataUseCaseProvider);
  final state = ref.read(dataProvider.notifier);

  return () async {
    // ユーザ操作で同期
    final remoteData = await useCase.syncFromRemote();
    if (remoteData != null) {
      state.state = remoteData;
    }
  };
});
*/
