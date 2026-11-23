import 'package:inblack_orders/core/database/user_data_store.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';

class AuthRepository {
  AuthRepository({
    required this._api,
    required this._session,
    required this._userData,
  });

  final AuthApi _api;
  final SessionManager _session;
  final UserDataStore _userData;

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.login(username: username, password: password);
    await _userData.prepareForUser(response.user.id);
    await _session.start(
      StoredSession(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.user.id,
      ),
    );
    return response.user;
  }

  Future<StoredSession?> currentSession() => _session.session();

  Future<void> clearSession() => _session.clear();
}
