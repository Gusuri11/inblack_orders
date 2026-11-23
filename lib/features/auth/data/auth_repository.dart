import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';

class AuthRepository {
  AuthRepository({required this._api, required this._storage});

  final AuthApi _api;
  final TokenStorage _storage;

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.login(username: username, password: password);
    await _storage.save(
      StoredSession(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.user.id,
      ),
    );
    return response.user;
  }

  Future<StoredSession?> currentSession() => _storage.read();

  Future<void> clearSession() => _storage.clear();
}
