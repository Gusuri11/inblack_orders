import 'package:dio/dio.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this._session, required this._retryDio});

  static const tokenKey = 'auth.token';
  static const retriedKey = 'auth.retried';

  final SessionManager _session;
  final Dio _retryDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _session.accessToken();
    if (token == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: ApiException(
            statusCode: 401,
            code: SessionEndReason.unauthorized.code,
          ),
        ),
      );
      return;
    }
    options.headers['Authorization'] = 'Bearer $token';
    options.extra[tokenKey] = token;
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final api = toApiException(err);
    if (api.statusCode != 401 || err.response == null) {
      handler.next(err);
      return;
    }

    if (!api.isTokenExpired) {
      await _session.end(SessionEndReason.fromCode(api.code));
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    final usedToken = options.extra[tokenKey];
    if (options.extra[retriedKey] == true || usedToken is! String) {
      handler.next(err);
      return;
    }

    try {
      await _session.refresh(failedAccessToken: usedToken);
      options.extra[retriedKey] = true;
      handler.resolve(await _retryDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    } on ApiException catch (e) {
      handler.next(
        DioException(requestOptions: options, error: e, type: err.type),
      );
    }
  }
}
