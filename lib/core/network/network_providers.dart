import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';

final dioProvider = Provider<Dio>((ref) {
  return createDio(baseUrl: AppConfig.baseUrl);
});
