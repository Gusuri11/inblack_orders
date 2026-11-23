import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/core/network/network_providers.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_interceptor.dart';
import 'package:inblack_orders/features/auth/data/auth_repository.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage();
});

final sessionManagerProvider = Provider<SessionManager>((ref) {
  final manager = SessionManager(
    api: ref.watch(authApiProvider),
    storage: ref.watch(tokenStorageProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});

final authenticatedDioProvider = Provider<Dio>((ref) {
  final dio = createDio(baseUrl: AppConfig.baseUrl);
  dio.interceptors.add(
    AuthInterceptor(session: ref.watch(sessionManagerProvider), retryDio: dio),
  );
  return dio;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.watch(authApiProvider),
    session: ref.watch(sessionManagerProvider),
    userData: ref.watch(appDatabaseProvider),
  );
});
