import '../../domain/entity/schedule_entity.dart';

enum ScheduleStatus { initial, loading, authenticated, unauthenticated }

enum ScheduleError { invalidCredentials, networkError, unknown }

class ScheduleState {
  final ScheduleStatus status;
  final ScheduleEntity? user;
  final ScheduleError? error;

  const ScheduleState({required this.status, this.user, this.error});

  factory ScheduleState.initial() =>
      const ScheduleState(status: ScheduleStatus.initial);

  ScheduleState copyWith({
    ScheduleStatus? status,
    ScheduleEntity? user,
    ScheduleError? error,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error, // null を渡せばリセットされる
    );
  }
}
