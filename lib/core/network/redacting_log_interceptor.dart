import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RedactingLogInterceptor extends Interceptor {
  static const _redacted = '***';
  static const _sensitiveKeys = {
    'authorization',
    'accesstoken',
    'refreshtoken',
    'access_token',
    'password',
  };

  void _log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('--> ${options.method} ${_safeUri(options.uri)}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(
      '<-- ${response.statusCode} ${response.requestOptions.method} '
      '${_safeUri(response.requestOptions.uri)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    _log(
      '<-- ERR ${code ?? err.type.name} ${err.requestOptions.method} '
      '${_safeUri(err.requestOptions.uri)}',
    );
    handler.next(err);
  }

  static Uri _safeUri(Uri uri) {
    if (uri.queryParameters.isEmpty) return uri;
    final masked = {
      for (final e in uri.queryParameters.entries)
        e.key: _sensitiveKeys.contains(e.key.toLowerCase())
            ? _redacted
            : e.value,
    };
    return uri.replace(queryParameters: masked);
  }
}
