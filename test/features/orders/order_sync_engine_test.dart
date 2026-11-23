import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/sync_state_dao.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_orders_server.dart';

Future<void> _noSleep(Duration _) async {}

void main() {
  late AppDatabase db;
  late FakeOrdersServer server;
  late FakeHttpAdapter adapter;

  OrderSyncEngine engine({int changesPageSize = 500}) => OrderSyncEngine(
    api: OrdersApi(fakeDio(adapter)),
    db: db,
    retry: const RetryPolicy(sleep: _noSleep),
    changesPageSize: changesPageSize,
  );

  Future<Set<String>> localIds() async =>
      (await db.select(db.orders).get()).map((r) => r.id).toSet();

  void useServer(FakeOrdersServer s) {
    server = s;
    adapter = FakeHttpAdapter(server.handle);
  }

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useServer(FakeOrdersServer(count: 1000));
  });
  tearDown(() => db.close());

  group('first sync', () {
    test('preloads the newest 200 orders in pages of 50', () async {
      server.seq = 77;
      await engine().sync();

      expect(adapter.countPath('/orders'), 4);
      final ids = await localIds();
      expect(ids, hasLength(200));
      expect(ids, containsAll(server.orders.take(200).map((o) => o.id)));

      final state = await db.syncStateDao.read();
      expect(state.syncSeq, 77);
      expect(state.olderCursor, isNotNull);
      expect(state.reachedEnd, isFalse);
      expect(state.lastSyncedAt, isNotNull);
    });

    test('a small account is loaded completely', () async {
      useServer(FakeOrdersServer(count: 30));
      await engine().sync();
      expect(await localIds(), hasLength(30));
      final state = await db.syncStateDao.read();
      expect(state.reachedEnd, isTrue);
      expect(state.olderCursor, isNull);
    });

    test('transient 5xx on a page is retried', () async {
      server.failNext.addAll([
        const FakeResponse(503, {'error': 'service_unavailable'}),
        const FakeResponse(500, {'error': 'internal_error'}),
      ]);
      await engine().sync();
      expect(await localIds(), hasLength(200));
    });

    test('4xx is not retried and leaves sync state untouched', () async {
      server.failNext.add(const FakeResponse(400, {'error': 'invalid_cursor'}));
      await expectLater(engine().sync(), throwsA(isA<ApiException>()));
      expect(adapter.countPath('/orders'), 1);
      expect((await db.syncStateDao.read()).syncSeq, isNull);
    });
  });

  group('incremental sync', () {
    late OrderSyncEngine sync;

    setUp(() async {
      sync = engine(changesPageSize: 2);
      await sync.sync();
      adapter.requests.clear();
    });

    test('applies upserts and tombstones, following hasMore', () async {
      final first = server.orders[0].id;
      final second = server.orders[1].id;
      server
        ..update(first, 'COMPLETED')
        ..remove(second)
        ..create('ORD-NEW', DateTime.utc(2027));

      await sync.sync();

      expect(adapter.countPath('/orders'), 0);
      expect(adapter.countPath('/orders/changes'), 2);
      final row = await db.ordersDao.findById(first);
      expect(row?.status, 'COMPLETED');
      expect(row?.version, 2);
      expect(await db.ordersDao.findById(second), isNull);
      expect(await db.ordersDao.findById('ORD-NEW'), isNotNull);
      expect((await db.syncStateDao.read()).syncSeq, server.seq);
    });

    test(
      'an older version in the feed does not overwrite newer local data',
      () async {
        final id = server.orders[0].id;
        await db.ordersDao.upsertAll([
          (await db.ordersDao.findById(id))!
              .toCompanion(false)
              .copyWith(
                status: const Value('REFUNDED'),
                version: const Value(9),
              ),
        ]);
        server.update(id, 'IN_PROGRESS');

        await sync.sync();

        final row = await db.ordersDao.findById(id);
        expect(row?.status, 'REFUNDED');
        expect(row?.version, 9);
      },
    );

    test('unknown change types are ignored', () async {
      server.extraChanges.add({'seq': 999, 'type': 'something_new'});
      await sync.sync();
      expect(await localIds(), hasLength(200));
    });

    test('nothing new keeps the cursor', () async {
      final before = (await db.syncStateDao.read()).syncSeq;
      await sync.sync();
      expect((await db.syncStateDao.read()).syncSeq, before);
      expect(adapter.countPath('/orders/changes'), 1);
    });
  });

  group('410 resync_required', () {
    test(
      'truncated change log triggers a full resync and keeps the outbox',
      () async {
        final sync = engine();
        await sync.sync();
        await db
            .into(db.outbox)
            .insert(
              OutboxCompanion.insert(
                orderId: server.orders[0].id,
                kind: 'cancel',
                payload: '{"reason":"x"}',
                idempotencyKey: 'key-00000001',
                createdAt: DateTime.utc(2026),
              ),
            );
        final gone = server.orders[3].id;
        server
          ..remove(gone)
          ..truncate()
          ..seq += 5;
        adapter.requests.clear();

        await sync.sync();

        expect(adapter.countPath('/orders/changes'), 2);
        expect(adapter.countPath('/orders'), 4);
        expect(await db.ordersDao.findById(gone), isNull);
        expect(await localIds(), hasLength(200));
        expect(await db.select(db.outbox).get(), hasLength(1));
        expect((await db.syncStateDao.read()).syncSeq, server.seq);
      },
    );

    test('server reset (local seq ahead of server) recovers', () async {
      server.seq = 500;
      final sync = engine();
      await sync.sync();
      server.reset();
      adapter.requests.clear();

      await sync.sync();

      expect(adapter.countPath('/orders'), 4);
      expect((await db.syncStateDao.read()).syncSeq, 0);
    });
  });

  group('loadOlder', () {
    test(
      'first sync records the oldest loaded order as the boundary',
      () async {
        await engine().sync();
        final state = await db.syncStateDao.read();
        expect(state.oldestKey?.id, server.orders[199].id);
      },
    );

    test('appends the next page and moves the boundary', () async {
      final sync = engine();
      await sync.sync();
      adapter.requests.clear();

      await sync.loadOlder();

      expect(adapter.countPath('/orders'), 1);
      expect(await localIds(), hasLength(250));
      final state = await db.syncStateDao.read();
      expect(state.oldestKey?.id, server.orders[249].id);
      expect(state.reachedEnd, isFalse);
    });

    test('reaching the last page marks the end', () async {
      useServer(FakeOrdersServer(count: 230));
      final sync = engine();
      await sync.sync();
      await sync.loadOlder();
      final state = await db.syncStateDao.read();
      expect(state.reachedEnd, isTrue);
      expect(await localIds(), hasLength(230));

      adapter.requests.clear();
      await sync.loadOlder();
      expect(adapter.requests, isEmpty);
    });

    test('without a previous sync it performs the first sync', () async {
      await engine().loadOlder();
      expect(await localIds(), hasLength(200));
    });

    test('an invalid cursor falls back to a full sync', () async {
      final sync = engine();
      await sync.sync();
      server.failNext.add(const FakeResponse(400, {'error': 'invalid_cursor'}));
      await sync.loadOlder();
      expect(
        (await db.syncStateDao.read()).oldestKey?.id,
        server.orders[199].id,
      );
    });

    test('loadOlder and sync never run at the same time', () async {
      final sync = engine();
      await sync.sync();
      server.update(server.orders[0].id, 'COMPLETED');
      await Future.wait([sync.loadOlder(), sync.sync(), sync.loadOlder()]);
      expect(await localIds(), hasLength(250));
      expect(
        (await db.ordersDao.findById(server.orders[0].id))?.status,
        'COMPLETED',
      );
    });
  });

  test('concurrent sync calls share a single run', () async {
    final sync = engine();
    await Future.wait([sync.sync(), sync.sync(), sync.sync()]);
    expect(adapter.countPath('/orders'), 4);
  });
}
