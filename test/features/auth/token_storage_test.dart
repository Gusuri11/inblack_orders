import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';
import 'package:inblack_orders/features/auth/data/auth_repository.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage;

class _MockAuthApi extends Mock implements AuthApi;

class _MemoryStorage implements TokenStorage {
  StoredSession? value;

  @override
  Future<StoredSession?> read() async => value;

  @override
  Future<void> save(StoredSession session) async => value = session;

  @override
  Future<void> clear() async => value = null;
}

void main() {
  group('SecureTokenStorage', () {
    late _MockSecureStorage backend;
    late SecureTokenStorage storage;

    setUp(() {
      backend = _MockSecureStorage();
      storage = SecureTokenStorage(backend);
      when(
        () => backend.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(() => backend.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
    });

    test('save writes tokens through the secure backend only', () async {
      await storage.save(
        const StoredSession(
          accessToken: 'at',
          refreshToken: 'rt',
          userId: 'u1',
        ),
      );
      verify(
        () => backend.write(key: SecureTokenStorage.accessKey, value: 'at'),
      ).called(1);
      verify(
        () => backend.write(key: SecureTokenStorage.refreshKey, value: 'rt'),
      ).called(1);
      verify(
        () => backend.write(key: SecureTokenStorage.userIdKey, value: 'u1'),
      ).called(1);
    });

    test('read returns null when a token is missing', () async {
      when(() => backend.read(key: SecureTokenStorage.accessKey))
          .thenAnswer((_) async => 'at');
      when(() => backend.read(key: SecureTokenStorage.refreshKey))
          .thenAnswer((_) async => null);
      expect(await storage.read(), isNull);
    });

    test('read returns the stored session', () async {
      when(() => backend.read(key: SecureTokenStorage.accessKey))
          .thenAnswer((_) async => 'at');
      when(() => backend.read(key: SecureTokenStorage.refreshKey))
          .thenAnswer((_) async => 'rt');
      when(() => backend.read(key: SecureTokenStorage.userIdKey))
          .thenAnswer((_) async => 'u1');
      final session = await storage.read();
      expect(session?.accessToken, 'at');
      expect(session?.refreshToken, 'rt');
      expect(session?.userId, 'u1');
    });

    test('clear removes every key', () async {
      await storage.clear();
      verify(() => backend.delete(key: SecureTokenStorage.accessKey)).called(1);
      verify(() => backend.delete(key: SecureTokenStorage.refreshKey))
          .called(1);
      verify(() => backend.delete(key: SecureTokenStorage.userIdKey)).called(1);
    });
  });

  group('AuthRepository', () {
    test('login persists the session and returns the user', () async {
      final api = _MockAuthApi();
      final storage = _MemoryStorage();
      const user = AuthUser(id: 'u1', username: 'alice', displayName: 'A');
      when(() => api.login(username: 'alice', password: 'pw')).thenAnswer(
        (_) async => const LoginResponse(
          accessToken: 'at',
          refreshToken: 'rt',
          expiresIn: 60,
          refreshExpiresIn: 604800,
          user: user,
        ),
      );

      final repo = AuthRepository(api: api, storage: storage);
      final result = await repo.login(username: 'alice', password: 'pw');

      expect(result, user);
      expect(storage.value?.refreshToken, 'rt');
      expect(storage.value?.userId, 'u1');
    });

    test('failed login stores nothing', () async {
      final api = _MockAuthApi();
      final storage = _MemoryStorage();
      when(
        () => api.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('401'));

      final repo = AuthRepository(api: api, storage: storage);
      await expectLater(
        repo.login(username: 'a', password: 'b'),
        throwsException,
      );
      expect(storage.value, isNull);
    });

    test('clearSession wipes the stored tokens', () async {
      final storage = _MemoryStorage()
        ..value = const StoredSession(accessToken: 'a', refreshToken: 'r');
      final repo = AuthRepository(api: _MockAuthApi(), storage: storage);
      await repo.clearSession();
      expect(await repo.currentSession(), isNull);
    });
  });
}
