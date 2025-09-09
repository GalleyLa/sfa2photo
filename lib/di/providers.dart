import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/repository/auth_repository.dart';
import '../application/usecases/auth_usecase.dart';
import '../infrastructure/auth_repository_impl.dart';
import '../infrastructure/service/auth_api_service.dart';

/// FlutterSecureStorage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// AuthApiService Provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? "https://fallback.example.com";
  return AuthApiService(baseUrl);
});

/// AuthRepository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(apiService, storage);
});

/// AuthUseCase Provider
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthUseCase(repo);
});
