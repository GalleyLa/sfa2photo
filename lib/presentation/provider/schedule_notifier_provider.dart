import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/schedule_usecase.dart';
import '../../domain/entity/schedule_entity.dart';
import 'common_providers.dart';
import '../state/schedule_state.dart';

class ScheduleNotifier extends StateNotifier<AsyncValue<List<ScheduleEntity>>> {
  final ScheduleUseCase _useCase;

  ScheduleNotifier(this._useCase) : super(const AsyncValue.data([]));

  Future<void> fetch() async {
    state = const AsyncValue.loading();

    try {
      final schedules = await _useCase.execute();
      state = AsyncValue.data(schedules);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Notifier Provider
final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, AsyncValue<List<ScheduleEntity>>>((
      ref,
    ) {
      final useCase = ref.watch(scheduleUseCaseProvider);
      return ScheduleNotifier(useCase);
    });
