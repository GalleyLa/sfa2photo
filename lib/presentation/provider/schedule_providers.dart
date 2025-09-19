// lib/presentation/provider/schedule_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../application/usecases/schedule_usecase.dart';
import '../../domain/entity/schedule_entity.dart';
import '../../domain/repository/schedule_repository.dart';
import '../../infrastructure/schedule_repository_impl.dart';
import '../../infrastructure/service/schedule_api_service.dart';
import '../../infrastructure/service/base_api_service.dart';
import '../../infrastructure/service/auth_api_service.dart';
import '../../infrastructure/schedule_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ScheduleNotifier extends StateNotifier<AsyncValue<List<ScheduleEntity>>> {
  final ScheduleUseCase _useCase;

  ScheduleNotifier(this._useCase) : super(const AsyncValue.loading());

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

// AuthApiService の Provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? "https://fallback.example.com";
  return AuthApiService(baseUrl);
});

// BaseApiService の Provider
final baseApiServiceProvider = Provider<BaseApiService>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  final storage = const FlutterSecureStorage();
  return BaseApiService(authApiService, storage);
});

// ScheduleApiService の Provider
final scheduleApiServiceProvider = Provider<ScheduleApiService>((ref) {
  final baseApiService = ref.watch(baseApiServiceProvider);
  return ScheduleApiService(baseApiService);
});

// Repository の Provider
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final apiService = ref.watch(scheduleApiServiceProvider);
  return ScheduleRepositoryImpl(apiService: apiService);
});

// UseCase の Provider
final scheduleUseCaseProvider = Provider<ScheduleUseCase>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleUseCase(repository);
});

// Notifier の Provider
final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, AsyncValue<List<ScheduleEntity>>>((
      ref,
    ) {
      final useCase = ref.watch(scheduleUseCaseProvider);
      return ScheduleNotifier(useCase);
    });

/*
// Repository の Provider
final scheduleRepositoryProvider = Provider<ScheduleRepositoryImpl>((ref) {
  return ScheduleRepositoryImpl(
    client: http.Client(),
    localDataSource: LocalScheduleDataSource(),
  );
});

// UseCase の Provider
final fetchSchedulesUseCaseProvider = Provider<FetchSchedulesUseCase>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return FetchSchedulesUseCase(repository);
});

// StateNotifier（UI 状態管理）

*/

// Notifier の Provider
/*
final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, AsyncValue<List<ScheduleEntity>>>((
      ref,
    ) {
      final useCase = ref.watch(fetchSchedulesUseCaseProvider);
      return ScheduleNotifier(useCase);
    });
*/
