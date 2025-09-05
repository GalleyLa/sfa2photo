import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/repository/auth_repository.dart';
import '../application/auth_usecase.dart';
import '../infrastructure/auth_repository_impl.dart';
import '../infrastructure/service/auth_api_service.dart';

final getIt = GetIt.instance;

void setupLocator({required String baseUrl}) {
  // 外部ライブラリ
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // サービス
  getIt.registerLazySingleton(() => AuthApiService(baseUrl));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthApiService>(),
      getIt<FlutterSecureStorage>(),
    ),
  );

  // UseCase
  getIt.registerFactory(() => AuthUseCase(getIt<AuthRepository>()));
}
