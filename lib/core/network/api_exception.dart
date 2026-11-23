import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({
    this.statusCode,
    this.code,
    this.message,
    this.retryAfter,
    this.body,
    this.isNetworkError = false,
    this.isTimeout = false,
  });

  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    if (response == null) {
      return ApiException(
        isNetworkError: true,
        isTimeout:
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout,
        message: e.message,
      );
    }

    final data = response.data;
    final body = data is Map<String, dynamic> ? data : null;
    return ApiException(
      statusCode: response.statusCode,
      code: body?['error'] as String?,
      message: body?['message'] as String?,
      retryAfter: _parseRetryAfter(response.headers.value('retry-after')),
      body: body,
    );
  }

  final int? statusCode;
  final String? code;
  final String? message;

  final Duration? retryAfter;

  final Map<String, dynamic>? body;

  final bool isNetworkError;
  final bool isTimeout;

  bool get isServerError => (statusCode ?? 0) >= 500;
  bool get isTokenExpired => statusCode == 401 && code == 'token_expired';

  bool get isRetryable => isNetworkError || isServerError || statusCode == 429;

  static Duration? _parseRetryAfter(String? value) {
    final seconds = int.tryParse(value ?? '');
    return seconds == null ? null : Duration(seconds: seconds);
  }

  @override
  String toString() =>
      'ApiException(status: $statusCode, code: $code, network: $isNetworkError)';
}
