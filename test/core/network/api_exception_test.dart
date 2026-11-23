import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/api_exception.dart';

DioException _dioError({
  int? status,
  Object? data,
  Map<String, List<String>>? headers,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: status,
            data: data,
            headers: Headers.fromMap(headers ?? {}),
          ),
  );
}

void main() {
  group('ApiException.fromDio', () {
    test('parses error code, message and Retry-After', () {
      final e = ApiException.fromDio(
        _dioError(
          status: 429,
          data: {'error': 'too_many_attempts', 'message': 'wait'},
          headers: {
            'retry-after': ['30'],
          },
        ),
      );
      expect(e.statusCode, 429);
      expect(e.code, 'too_many_attempts');
      expect(e.retryAfter, const Duration(seconds: 30));
      expect(e.isRetryable, isTrue);
    });

    test('token_expired is detected', () {
      final e = ApiException.fromDio(
        _dioError(status: 401, data: {'error': 'token_expired'}),
      );
      expect(e.isTokenExpired, isTrue);
    });

    test('401 unauthorized is not token_expired', () {
      final e = ApiException.fromDio(
        _dioError(status: 401, data: {'error': 'unauthorized'}),
      );
      expect(e.isTokenExpired, isFalse);
    });

    test('no response is a retryable network error', () {
      final e = ApiException.fromDio(
        _dioError(type: DioExceptionType.connectionError),
      );
      expect(e.isNetworkError, isTrue);
      expect(e.isRetryable, isTrue);
    });

    test('timeouts are flagged', () {
      final e = ApiException.fromDio(
        _dioError(type: DioExceptionType.receiveTimeout),
      );
      expect(e.isTimeout, isTrue);
    });

    test('4xx other than 429 is not retryable', () {
      final e = ApiException.fromDio(
        _dioError(status: 422, data: {'error': 'not_cancellable'}),
      );
      expect(e.isRetryable, isFalse);
    });

    test('non-JSON error body does not crash', () {
      final e = ApiException.fromDio(_dioError(status: 503, data: 'oops'));
      expect(e.code, isNull);
      expect(e.isServerError, isTrue);
    });
  });
}
