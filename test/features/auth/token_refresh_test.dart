import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_interceptor.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/memory_token_storage.dart';

class _FakeAuthServer {
  String validAccess = 'at1';
  String currentRefresh = 'rt1';
  final usedRefresh = <String>{};
  int generation = 1;
  final List<FakeResponse> refreshScript = [];
  FakeResponse? dataOverride;
  final seenAuth = <String?>[];

  FutureOr<FakeResponse> handle(RequestOptions r) async {
    if (r.path == '/auth/refresh') {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (refreshScript.isNotEmpty) return refreshScript.removeAt(0);
      final body = r.data as Map<String, dynamic>;
      final token = body['refreshToken'] as String;
      if (usedRefresh.contains(token)) {
        return const FakeResponse(401, {'error': 'refresh_token_reused'});
      }
      if (token != currentRefresh) {
        return const FakeResponse(401, {'error': 'invalid_grant'});
      }
      usedRefresh.add(token);
      generation++;
      validAccess = 'at$generation';
      currentRefresh = 'rt$generation';
      return FakeResponse(200, {
        'accessToken': validAccess,
        'refreshToken': currentRefresh,
        'tokenType': 'Bearer',
        'expiresIn': 60,
        'refreshExpiresIn': 604800,
      });
    }

    final auth = r.headers['Authorization'] as String?;
    seenAuth.add(auth);
    final override = dataOverride;
    if (override != null) return override;
    if (auth != 'Bearer $validAccess') {
      return const FakeResponse(401, {'error': 'token_expired'});
    }
    return FakeResponse(200, {'path': r.path, 'ok': true});
  }
}

void main() {
  late _FakeAuthServer server;
  late FakeHttpAdapter adapter;
  late MemoryTokenStorage storage;
  late SessionManager session;
  late Dio dio;

  setUp(() async {
    server = _FakeAuthServer();
    adapter = FakeHttpAdapter(server.handle);
    storage = MemoryTokenStorage(
      const StoredSession(accessToken: 'at1', refreshToken: 'rt1', userId: 'u'),
    );
    session = SessionManager(
      api: AuthApi(fakeDio(adapter)),
      storage: storage,
      retryDelay: Duration.zero,
    );
    dio = fakeDio(adapter);
    dio.interceptors.add(AuthInterceptor(session: session, retryDio: dio));
    server.validAccess = 'at_expired';
  });

  tearDown(() => session.dispose());

  Future<List<Response<dynamic>>> fireConcurrent(int n) =>
      Future.wait([for (var i = 0; i < n; i++) dio.get<dynamic>('/orders/$i')]);

  test('5 concurrent 401 token_expired trigger exactly one refresh', () async {
    final responses = await fireConcurrent(5);

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(adapter.countPath('/auth/refresh'), 1);
    expect(server.usedRefresh, {'rt1'});
    expect(storage.value?.accessToken, 'at2');
    expect(storage.value?.refreshToken, 'rt2');
    expect(server.seenAuth.where((h) => h == 'Bearer at1'), hasLength(5));
    expect(server.seenAuth.where((h) => h == 'Bearer at2'), hasLength(5));
  });

  test('a late 401 carrying the old token reuses the new token', () async {
    await dio.get<dynamic>('/orders/a');
    expect(adapter.countPath('/auth/refresh'), 1);

    await session.refresh(failedAccessToken: 'at1');
    expect(adapter.countPath('/auth/refresh'), 1);
  });

  test('two waves of expiry refresh once per wave', () async {
    await fireConcurrent(5);
    server.validAccess = 'at_expired_again';
    await fireConcurrent(5);
    expect(adapter.countPath('/auth/refresh'), 2);
    expect(server.usedRefresh, {'rt1', 'rt2'});
  });

  test('503 during refresh is retried and does not log out', () async {
    server.refreshScript.add(
      const FakeResponse(
        503,
        {'error': 'service_unavailable'},
        {'retry-after': '0'},
      ),
    );

    final responses = await fireConcurrent(5);

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(adapter.countPath('/auth/refresh'), 2);
    expect(storage.value?.refreshToken, 'rt2');
  });

  test('persistent 503 fails the requests but keeps the session', () async {
    final ended = <SessionEndReason>[];
    session.sessionEnded.listen(ended.add);
    server.refreshScript.addAll(
      List.filled(3, const FakeResponse(503, {'error': 'service_unavailable'})),
    );

    final results = await Future.wait([
      for (var i = 0; i < 5; i++)
        dio
            .get<dynamic>('/orders/$i')
            .then<Object>((r) => r, onError: (Object e) => e),
    ]);

    for (final r in results) {
      expect(toApiException(r).statusCode, 503);
    }
    expect(adapter.countPath('/auth/refresh'), 3);
    expect(storage.value?.refreshToken, 'rt1');
    expect(ended, isEmpty);
  });

  test(
    'network error during refresh is not retried and keeps the session',
    () async {
      server.refreshScript.clear();
      adapter.handler = (r) =>
          r.path == '/auth/refresh' ? throwNetworkError() : server.handle(r);

      final error = await dio
          .get<dynamic>('/orders/1')
          .then<Object>((r) => r, onError: (Object e) => e);

      expect(toApiException(error).isNetworkError, isTrue);
      expect(adapter.countPath('/auth/refresh'), 1);
      expect(storage.value, isNotNull);
    },
  );

  test('refresh_token_reused ends the session', () async {
    final ended = <SessionEndReason>[];
    session.sessionEnded.listen(ended.add);
    server.usedRefresh.add('rt1');

    final error = await dio
        .get<dynamic>('/orders/1')
        .then<Object>((r) => r, onError: (Object e) => e);

    expect(toApiException(error).code, 'refresh_token_reused');
    expect(storage.value, isNull);
    await Future<void>.delayed(Duration.zero);
    expect(ended, [SessionEndReason.refreshTokenReused]);
  });

  test(
    'token_revoked on a data endpoint ends the session without refresh',
    () async {
      final ended = <SessionEndReason>[];
      session.sessionEnded.listen(ended.add);
      server.dataOverride = const FakeResponse(401, {'error': 'token_revoked'});

      await expectLater(
        dio.get<dynamic>('/orders/1'),
        throwsA(isA<DioException>()),
      );

      expect(adapter.countPath('/auth/refresh'), 0);
      expect(storage.value, isNull);
      await Future<void>.delayed(Duration.zero);
      expect(ended, [SessionEndReason.tokenRevoked]);
    },
  );

  test('requests without a session are rejected locally', () async {
    await session.clear();
    final error = await dio
        .get<dynamic>('/orders/1')
        .then<Object>((r) => r, onError: (Object e) => e);
    expect(toApiException(error).statusCode, 401);
    expect(adapter.requests, isEmpty);
  });
}
