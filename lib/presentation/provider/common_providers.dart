import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sfa2photo/infrastructure/local/datasources/schedule_local_datasource.dart';

import '../../infrastructure/service/auth_api_service.dart';
import '../../infrastructure/service/base_api_service.dart';
import '../../infrastructure/service/schedule_api_service.dart';
import '../../infrastructure/usecases/schedule_repository_impl.dart';
import '../../infrastructure/usecases/schedule_localdb_impl.dart';

import '../../domain/repository/schedule_repository.dart';
import '../../application/usecases/schedule_usecase.dart';
import '../../shared/utils/date_formatter_provider.dart';

import 'database_provider.dart';

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
  return BaseApiService(authApiService);
  //final storage = ref.watch(secureStorageProvider);
  //return BaseApiService(authApiService, storage);
});

// ----------------------------
// ScheduleApiService Provider
// ----------------------------
final scheduleApiServiceProvider = Provider<ScheduleApiService>((ref) {
  final baseApiService = ref.watch(baseApiServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return ScheduleApiService(
    baseApiService,
    storage,
    ref.watch(dateFormatterProvider),
  );
});

// ----------------------------
// Local DB Provider
// ----------------------------
final scheduleLocalDbProvider = FutureProvider<ScheduleLocalDataSource>((
  ref,
) async {
  //final db = ref.watch(databaseProvider).value;
  final db = await ref.watch(databaseProvider.future);
  //if (db == null) {
  //  throw Exception('Database is not ready');
  //}
  return ScheduleLocalDataSource(db);
});

//final scheduleLocalDataSourceProvider = FutureProvider<ScheduleLocalDataSource>(
//  (ref) async {
//    final db = await ref.watch(databaseProvider.future);
//    return ScheduleLocalDataSource(db);
//  },
//);
// ----------------------------
// ScheduleRepository Provider
// ----------------------------
final scheduleRepositoryProvider = FutureProvider<ScheduleRepository>((
  ref,
) async {
  final localDb = await ref.watch(scheduleLocalDbProvider.future);
  final apiService = ref.watch(scheduleApiServiceProvider);
  return ScheduleRepositoryImpl(localDb: localDb, apiService: apiService);
});

// ----------------------------
// ScheduleUseCase Provider
// ----------------------------
final scheduleUseCaseProvider = FutureProvider<ScheduleUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return ScheduleUseCase(repository);
});
