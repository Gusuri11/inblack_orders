import 'package:dio/dio.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final json = await _post('/auth/login', {
      'username': username,
      'password': password,
    });
    return LoginResponse.fromJson(json);
  }

  Future<RefreshResponse> refresh(String refreshToken) async {
    final json = await _post('/auth/refresh', {'refreshToken': refreshToken});
    return RefreshResponse.fromJson(json);
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw toApiException(e);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Empty response body');
      }
      return data;
    } on DioException catch (e) {
      throw toApiException(e);
    }
  }
}
