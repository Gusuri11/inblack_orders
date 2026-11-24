import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';

final baseUrlProvider = Provider<String>((ref) {
  if (!AppConfig.isDev) return AppConfig.baseUrl;
  return ref.watch(settingsProvider.select((s) => s.baseUrlOverride)) ??
      AppConfig.baseUrl;
});

final dioProvider = Provider<Dio>((ref) {
  return createDio(baseUrl: ref.watch(baseUrlProvider));
});
