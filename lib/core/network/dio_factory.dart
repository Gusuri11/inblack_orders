import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/redacting_log_interceptor.dart';

class _ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: ApiException.fromDio(err)));
  }
}

Dio createDio({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    ),
  )..interceptors.add(_ApiErrorInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(RedactingLogInterceptor());
  }
  return dio;
}

ApiException toApiException(Object error) {
  if (error is ApiException) return error;
  if (error is DioException) {
    final inner = error.error;
    return inner is ApiException ? inner : ApiException.fromDio(error);
  }
  return ApiException(message: error.toString());
}
