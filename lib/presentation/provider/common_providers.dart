import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../infrastructure/local/datasources/schedule_local_datasource.dart';

import '../../infrastructure/local/datasources/image_local_datasource.dart';
//import '../../infrastructure/local/db/tables/image_table.dart';
import '../../infrastructure/usecases/image_repository_impl.dart';
import '../../domain/repository/image_repository.dart';

import '../../infrastructure/service/auth_api_service.dart';
import '../../infrastructure/service/base_api_service.dart';
import '../../infrastructure/service/schedule_api_service.dart';
import '../../infrastructure/usecases/schedule_repository_impl.dart';
//import '../../infrastructure/usecases/schedule_localdb_impl.dart';
import '../../domain/entity/schedule_entity.dart';
import '../../domain/repository/schedule_repository.dart';
import '../../domain/repository/image_repository.dart';

import '../../application/usecases/delete_image_usecase.dart';

import '../../application/usecases/schedule_usecase.dart';
import '../../application/usecases/load_schedule_usecase.dart';
import '../../application/usecases/schedule_usecase.dart';

import '../../application/usecases/save_image_usecase.dart';
import '../../application/usecases/fetch_image_usecase.dart';
import '../../application/usecases/delete_image_usecase.dart';

import '../../shared/utils/date_formatter_provider.dart';
import '../viewmodel/schedule_view_model.dart';

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
  final db = await ref.watch(databaseProvider.future);
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

// UseCase Provider（同期）
final loadSchedulesUseCaseProvider = FutureProvider<LoadSchedulesUseCase>((
  ref,
) async {
  final repo = await ref.watch(scheduleRepositoryProvider.future);
  return LoadSchedulesUseCase(repo);
});

// ----------------------------
// スケジュール一覧取得（FutureProvider）
// ----------------------------
final schedulesProvider = FutureProvider<List<ScheduleEntity>>((ref) async {
  final usecase = await ref.watch(loadSchedulesUseCaseProvider.future);
  return usecase.execute();
});

// =====================================================
//  Image（画像保存）関連 Provider
// =====================================================

// --- Local DataSource ---
final imageLocalDataSourceProvider = FutureProvider<ImageLocalDatasource>((
  ref,
) async {
  final db = await ref.watch(databaseProvider.future);
  return ImageLocalDatasource(db);
});

// --- Repository ---
final imageRepositoryProvider = FutureProvider<ImageRepository>((ref) async {
  final localDb = await ref.watch(imageLocalDataSourceProvider.future);
  return ImageRepositoryImpl(localDb: localDb);
});

// --- UseCase ---
final saveImageUseCaseProvider = FutureProvider<SaveImageUseCase>((ref) async {
  final repo = await ref.watch(imageRepositoryProvider.future);
  return SaveImageUseCase(repo);
});

final fetchImagesUseCaseProvider = FutureProvider<FetchImagesUseCase>((
  ref,
) async {
  final repo = await ref.watch(imageRepositoryProvider.future);
  return FetchImagesUseCase(repo);
});

// DeleteImageUseCase Provider
final deleteImageUseCaseProvider = FutureProvider<DeleteImageUseCase>((
  ref,
) async {
  final repo = await ref.watch(imageRepositoryProvider.future);
  return DeleteImageUseCase(repo);
});

// ViewModel Provider
final scheduleViewModelProvider =
    AsyncNotifierProvider<ScheduleViewModel, void>(() {
      return ScheduleViewModel();
    });
