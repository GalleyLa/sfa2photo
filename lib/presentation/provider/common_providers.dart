import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../infrastructure/service/auth_api_service.dart';
import '../../infrastructure/service/base_api_service.dart';
import '../../infrastructure/service/schedule_api_service.dart';
import '../../infrastructure/schedule_repository_impl.dart';
import '../../domain/repository/schedule_repository.dart';
import '../../application/usecases/schedule_usecase.dart';

// ----------------------------
// SecureStorage Provider
// ----------------------------
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ----------------------------
// AuthApiService Provider（共通）
// ----------------------------
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? "https://fallback.example.com";
  return AuthApiService(baseUrl);
});

// ----------------------------
// BaseApiService Provider
// ----------------------------
final baseApiServiceProvider = Provider<BaseApiService>((ref) {
  final authApiService = ref.watch(authApiServiceProvider); // 共通インスタンス
  final storage = ref.watch(secureStorageProvider);
  return BaseApiService(authApiService, storage);
});

// ----------------------------
// ScheduleApiService Provider
// ----------------------------
final scheduleApiServiceProvider = Provider<ScheduleApiService>((ref) {
  final baseApiService = ref.watch(baseApiServiceProvider);
  return ScheduleApiService(baseApiService);
});

// ----------------------------
// ScheduleRepository Provider
// ----------------------------
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final apiService = ref.watch(scheduleApiServiceProvider);
  return ScheduleRepositoryImpl(apiService: apiService);
});

// ----------------------------
// ScheduleUseCase Provider
// ----------------------------
final scheduleUseCaseProvider = Provider<ScheduleUseCase>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleUseCase(repository);
});
