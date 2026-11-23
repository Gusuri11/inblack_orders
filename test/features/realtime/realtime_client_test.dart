import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';
import 'package:inblack_orders/features/realtime/data/order_event_applier.dart';
import 'package:inblack_orders/features/realtime/data/realtime_client.dart';
import 'package:inblack_orders/features/realtime/data/realtime_event.dart';
import 'package:inblack_orders/features/realtime/data/realtime_socket.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fake_network_status.dart';
import '../../helpers/memory_token_storage.dart';

class _MockAuthApi extends Mock implements AuthApi;

class FakeSocket implements RealtimeSocket {
  FakeSocket(this.uri);

  final Uri uri;
  final _ready = Completer<void>();
  final _incoming = StreamController<dynamic>();
  final sent = <Map<String, dynamic>>[];
  bool closed = false;

  @override
  int? closeCode;

  String? get token => uri.queryParameters['access_token'];

  void open() => _ready.complete();

  void reject() => _ready.completeError(StateError('401'));

  void push(Map<String, dynamic> message) => _incoming.add(jsonEncode(message));

  void hello({int syncSeq = 10, int heartbeatSec = 15}) =>
      push({'type': 'hello', 'syncSeq': syncSeq, 'heartbeatSec': heartbeatSec});

  void serverClose(int code) {
    closeCode = code;
    unawaited(_incoming.close());
  }

  @override
  Future<void> get ready => _ready.future;

  @override
  Stream<dynamic> get messages => _incoming.stream;

  @override
  void send(String text) => sent.add(jsonDecode(text) as Map<String, dynamic>);

  @override
  Future<void> close([int? code]) async {
    closed = true;
    if (!_incoming.isClosed) await _incoming.close();
  }
}

class _RecordingSink implements OrderEventSink {
  final hellos = <Hello>[];
  final events = <OrderEvent>[];

  @override
  Future<void> onHello(Hello hello) async => hellos.add(hello);

  @override
  Future<void> onEvent(OrderEvent event) async => events.add(event);
}

RefreshResponse _refreshed(String n) => RefreshResponse(
  accessToken: 'at$n',
  refreshToken: 'rt$n',
  expiresIn: 60,
  refreshExpiresIn: 604800,
);

void main() {
  late _MockAuthApi api;
  late MemoryTokenStorage storage;
  late FakeNetworkStatus network;
  late _RecordingSink sink;
  late List<FakeSocket> sockets;
  late int verifyCalls;
  late Future<void> Function() verifyImpl;
  late bool autoOpen;

  setUp(() {
    api = _MockAuthApi();
    storage = MemoryTokenStorage(
      const StoredSession(accessToken: 'at1', refreshToken: 'rt1', userId: 'u'),
    );
    network = FakeNetworkStatus();
    sink = _RecordingSink();
    sockets = [];
    verifyCalls = 0;
    verifyImpl = () async => verifyCalls++;
    autoOpen = true;
  });

  void run(
    void Function(
      FakeAsync async,
      RealtimeClient client,
      SessionManager session,
    )
    body,
  ) {
    fakeAsync((async) {
      final clock = async.getClock(DateTime.utc(2026, 11, 6));
      final session = SessionManager(
        api: api,
        storage: storage,
        retryDelay: Duration.zero,
        clock: clock.now,
      );
      final client = RealtimeClient(
        baseUrl: Uri.parse('http://server:8787'),
        session: session,
        sink: sink,
        connector: (uri) {
          final s = FakeSocket(uri);
          sockets.add(s);
          if (autoOpen) s.open();
          return s;
        },
        network: network,
        verifySession: () => verifyImpl(),
        random: Random(7),
        clock: clock.now,
      );
      body(async, client, session);
      unawaited(client.dispose());
      async.flushMicrotasks();
    });
  }

  void connectLive(FakeAsync async, RealtimeClient client) {
    unawaited(client.setEnabled(enabled: true));
    async.flushMicrotasks();
    sockets.last.hello();
    async.flushMicrotasks();
  }

  test('connects with the access token and goes live on hello', () {
    run((async, client, _) {
      connectLive(async, client);
      expect(sockets, hasLength(1));
      expect(sockets.single.uri.scheme, 'ws');
      expect(sockets.single.uri.path, '/ws');
      expect(sockets.single.token, 'at1');
      expect(client.current, ConnectionStatus.live);
      expect(sink.hellos.single.syncSeq, 10);
    });
  });

  test('order events are forwarded, junk is ignored', () {
    run((async, client, _) {
      connectLive(async, client);
      sockets.last
        ..push({
          'type': 'order.updated',
          'seq': 11,
          'order': {'id': 'A', 'status': 'PAID', 'version': 2},
        })
        ..push({'type': 'order.deleted', 'seq': 12, 'id': 'B'})
        ..push({'type': 'something.else', 'seq': 13});
      sockets.last._incoming.add('not json');
      async.flushMicrotasks();
      expect(sink.events.map((e) => e.seq), [11, 12]);
      expect(client.current, ConnectionStatus.live);
    });
  });

  test('going to background closes the socket, foreground reconnects', () {
    run((async, client, _) {
      connectLive(async, client);
      client.setForeground(foreground: false);
      async.flushMicrotasks();
      expect(sockets.single.closed, isTrue);
      expect(client.current, ConnectionStatus.offline);

      async.elapse(const Duration(minutes: 5));
      expect(sockets, hasLength(1));

      client.setForeground(foreground: true);
      async.flushMicrotasks();
      expect(sockets, hasLength(2));
    });
  });

  test('backoff starts around 1s, grows, and is capped at 30s', () {
    final random = Random(1);
    for (var attempt = 1; attempt <= 12; attempt++) {
      final full = min(30000, 1000 * pow(2, attempt - 1).toInt());
      final d = RealtimeClient.backoffFor(attempt, random).inMilliseconds;
      expect(d, inInclusiveRange(full ~/ 2, full), reason: 'attempt $attempt');
    }
  });

  test('a dropped connection reconnects after a backoff delay', () {
    run((async, client, _) {
      connectLive(async, client);
      sockets.last.serverClose(1012);
      async.flushMicrotasks();
      expect(client.current, ConnectionStatus.reconnecting);

      async.elapse(const Duration(milliseconds: 499));
      expect(sockets, hasLength(1));
      async.elapse(const Duration(milliseconds: 501));
      expect(sockets, hasLength(2));

      sockets.last.hello();
      async.flushMicrotasks();
      expect(client.current, ConnectionStatus.live);
      expect(client.attempt, 0);
    });
  });

  test('repeated failures keep backing off without exceeding 30s', () {
    run((async, client, _) {
      autoOpen = false;
      unawaited(client.setEnabled(enabled: true));
      async.flushMicrotasks();
      for (var i = 0; i < 10; i++) {
        sockets.last.reject();
        async.flushMicrotasks();
        final before = sockets.length;
        async.elapse(const Duration(seconds: 30));
        expect(sockets.length, before + 1, reason: 'failure $i');
      }
      expect(client.attempt, 10);
      expect(verifyCalls, 10);
    });
  });

  test('a silent (stalled) connection is detected and replaced', () {
    run((async, client, _) {
      connectLive(async, client);
      async.elapse(const Duration(seconds: 30));
      expect(sockets, hasLength(1));
      async.elapse(const Duration(seconds: 10));
      expect(sockets.first.closed, isTrue);
      async.elapse(const Duration(seconds: 2));
      expect(sockets, hasLength(2));
    });
  });

  test('heartbeats keep the connection alive and pings are sent', () {
    run((async, client, _) {
      connectLive(async, client);
      for (var i = 0; i < 8; i++) {
        async.elapse(const Duration(seconds: 15));
        sockets.single.push({'type': 'heartbeat'});
        async.flushMicrotasks();
      }
      expect(sockets, hasLength(1));
      expect(
        sockets.single.sent.where((m) => m['type'] == 'ping'),
        hasLength(8),
      );
    });
  });

  test('4001 refreshes once and reconnects immediately with the new token', () {
    when(() => api.refresh('rt1')).thenAnswer((_) async => _refreshed('2'));
    run((async, client, _) {
      connectLive(async, client);
      sockets.last.serverClose(4001);
      async.flushMicrotasks();
      expect(sockets, hasLength(2));
      expect(sockets.last.token, 'at2');
      verify(() => api.refresh('rt1')).called(1);
    });
  });

  test('4003 ends the session and stops reconnecting', () {
    run((async, client, session) {
      final ended = <SessionEndReason>[];
      session.sessionEnded.listen(ended.add);
      connectLive(async, client);
      sockets.last.serverClose(4003);
      async
        ..flushMicrotasks()
        ..elapse(const Duration(minutes: 2));
      expect(sockets, hasLength(1));
      expect(ended, [SessionEndReason.socketRevoked]);
      expect(storage.value, isNull);
      expect(client.current, ConnectionStatus.offline);
    });
  });

  test('no attempts while offline, immediate reconnect when back', () {
    run((async, client, _) {
      connectLive(async, client);
      network.set(online: false);
      async.flushMicrotasks();
      expect(sockets.single.closed, isTrue);
      expect(client.current, ConnectionStatus.offline);

      async.elapse(const Duration(minutes: 10));
      expect(sockets, hasLength(1));

      network.set(online: true);
      async.flushMicrotasks();
      expect(sockets, hasLength(2));
    });
  });

  test('a token refreshed elsewhere is pushed with an auth message', () {
    run((async, client, session) {
      connectLive(async, client);
      unawaited(
        session.start(
          const StoredSession(accessToken: 'at9', refreshToken: 'rt9'),
        ),
      );
      async.flushMicrotasks();
      expect(
        sockets.single.sent,
        contains(equals({'type': 'auth', 'accessToken': 'at9'})),
      );
    });
  });

  test('the token is renewed over the socket shortly before it expires', () {
    when(() => api.refresh('rt1')).thenAnswer((_) async => _refreshed('2'));
    run((async, client, session) {
      unawaited(
        session.start(
          const StoredSession(accessToken: 'at1', refreshToken: 'rt1'),
          expiresIn: const Duration(seconds: 60),
        ),
      );
      async.flushMicrotasks();
      connectLive(async, client);

      void beat(int seconds) {
        for (var i = 0; i < seconds; i++) {
          async.elapse(const Duration(seconds: 1));
          if (i % 10 == 0) sockets.single.push({'type': 'heartbeat'});
          async.flushMicrotasks();
        }
      }

      beat(49);
      verifyNever(() => api.refresh(any()));
      beat(2);
      verify(() => api.refresh('rt1')).called(1);
      expect(sockets.single.sent.where((m) => m['type'] == 'auth'), [
        {'type': 'auth', 'accessToken': 'at2'},
      ]);
      expect(sockets, hasLength(1));
    });
  });

  test(
    'a rejected handshake checks the session and retries with a fresh token',
    () {
      run((async, client, session) {
        autoOpen = false;
        verifyImpl = () async {
          verifyCalls++;
          await session.start(
            const StoredSession(accessToken: 'at2', refreshToken: 'rt2'),
          );
        };
        unawaited(client.setEnabled(enabled: true));
        async.flushMicrotasks();
        sockets.last.reject();
        async.flushMicrotasks();

        expect(verifyCalls, 1);
        expect(sockets, hasLength(2));
        expect(sockets.last.token, 'at2');
      });
    },
  );

  test('a revoked session found during the handshake stops the client', () {
    run((async, client, _) {
      autoOpen = false;
      verifyImpl = () async =>
          throw const ApiException(statusCode: 401, code: 'token_revoked');
      unawaited(client.setEnabled(enabled: true));
      async.flushMicrotasks();
      sockets.last.reject();
      async
        ..flushMicrotasks()
        ..elapse(const Duration(minutes: 1));
      expect(sockets, hasLength(1));
      expect(client.current, ConnectionStatus.offline);
    });
  });
}
