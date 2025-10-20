import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
//import '../../application/usecases/schedule_usecase.dart';
import '../../domain/entity/schedule_entity.dart';
import 'common_providers.dart';
import '../state/schedule_state.dart';

/// --- AsyncNotifier版 ScheduleNotifier ---
final scheduleNotifierProvider =
    AsyncNotifierProvider<ScheduleNotifier, List<ScheduleEntity>>(
      ScheduleNotifier.new,
    );

class ScheduleNotifier extends AsyncNotifier<List<ScheduleEntity>> {
  /// build() は初期ロード時に呼ばれる
  @override
  Future<List<ScheduleEntity>> build() async {
    return [];
    //final useCase = await ref.watch(scheduleUseCaseProvider.future);
    //return useCase.execute();
  }

  /// 手動で再取得（＝「同期ボタン」で再読込など）
  Future<void> fetch() async {
    state = const AsyncValue.loading();

    try {
      final useCase = await ref.watch(scheduleUseCaseProvider.future);
      final schedules = await useCase.execute();
      state = AsyncValue.data(schedules);
    } catch (e, st) {
      debugPrint(e.toString());
      state = AsyncValue.error(e, st);
    }
  }
}
