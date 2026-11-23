import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredSession {
  const StoredSession({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final String? userId;
}

abstract interface class TokenStorage {
  Future<StoredSession?> read();
  Future<void> save(StoredSession session);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? _defaultStorage;

  static const _defaultStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const accessKey = 'auth.access_token';
  static const refreshKey = 'auth.refresh_token';
  static const userIdKey = 'auth.user_id';

  final FlutterSecureStorage _storage;

  @override
  Future<StoredSession?> read() async {
    final access = await _storage.read(key: accessKey);
    final refresh = await _storage.read(key: refreshKey);
    if (access == null || refresh == null) return null;
    return StoredSession(
      accessToken: access,
      refreshToken: refresh,
      userId: await _storage.read(key: userIdKey),
    );
  }

  @override
  Future<void> save(StoredSession session) async {
    await _storage.write(key: accessKey, value: session.accessToken);
    await _storage.write(key: refreshKey, value: session.refreshToken);
    final userId = session.userId;
    if (userId == null) {
      await _storage.delete(key: userIdKey);
    } else {
      await _storage.write(key: userIdKey, value: userId);
    }
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: accessKey);
    await _storage.delete(key: refreshKey);
    await _storage.delete(key: userIdKey);
  }
}
