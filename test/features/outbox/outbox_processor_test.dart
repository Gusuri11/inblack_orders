import 'dart:math';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/outbox/data/outbox_processor.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_orders_server.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FakeOrdersServer server;
  late FakeHttpAdapter adapter;
  late OutboxRepository repo;
  late OutboxProcessor processor;
  late DateTime now;
  var keyCounter = 0;

  OutboxProcessor makeProcessor({int maxAttempts = 8}) => OutboxProcessor(
    api: OrdersApi(fakeDio(adapter)),
    db: db,
    maxAttempts: maxAttempts,
    random: Random(3),
    clock: () => now,
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    server = FakeOrdersServer(count: 3);
    server.orders[1].status = 'COMPLETED';
    adapter = FakeHttpAdapter(server.handle);
    now = DateTime.utc(2026, 11, 6, 12);
    keyCounter = 0;
    repo = OutboxRepository(
      db: db,
      clock: () => now,
      newKey: () => 'key-${(++keyCounter).toString().padLeft(8, '0')}',
    );
    processor = makeProcessor();
    await db.ordersDao.upsertAll([
      for (final o in server.orders)
        OrdersCompanion.insert(
          id: o.id,
          status: o.status,
          version: o.version,
          totalMinor: 17900,
          createdAt: o.createdAt,
          updatedAt: o.createdAt,
        ),
    ]);
  });

  tearDown(() async {
    processor.dispose();
    await db.close();
  });

  String a() => server.orders[0].id;
  String completed() => server.orders[1].id;
  String c() => server.orders[2].id;

  Future<List<OutboxRow>> rows() => db.outboxDao.all();

  void later(Duration d) => now = now.add(d);

  test('a cancel is sent once and the server result is stored', () async {
    await repo.enqueueCancel(
      orderId: a(),
      ifMatchVersion: 1,
      reason: 'เปลี่ยนใจ',
    );
    await processor.drain();

    expect(await rows(), isEmpty);
    expect(server.cancelsApplied, 1);
    final row = await db.ordersDao.findById(a());
    expect(row?.status, 'CANCELLED');
    expect(row?.version, 2);
    expect((await db.ordersDao.findDetail(a()))?.version, 2);
    final sent = adapter.requests.single;
    expect(sent.headers['If-Match'], '1');
    expect(sent.headers['Idempotency-Key'], 'key-00000001');
  });

  test(
    'a lost response is retried with the same key and applied once',
    () async {
      server.loseResponses = 1;
      await repo.enqueueNote(orderId: a(), text: 'ช่วยตรวจสอบด้วยครับ');

      await processor.drain();
      final pending = (await rows()).single;
      expect(pending.state, OutboxStates.pending);
      expect(pending.lastError, 'network');
      expect(pending.nextAttemptAt, isNotNull);
      expect(server.notesCreated, 1);

      later(const Duration(minutes: 2));
      await processor.drain();

      expect(await rows(), isEmpty);
      expect(server.notesCreated, 1);
      expect(server.seenKeys, ['key-00000001', 'key-00000001']);
    },
  );

  test('5xx backs off and honours Retry-After', () async {
    server.failNext.add(
      const FakeResponse(
        503,
        {'error': 'service_unavailable'},
        {'retry-after': '7'},
      ),
    );
    await repo.enqueueNote(orderId: a(), text: 'hi');
    await processor.drain();

    final row = (await rows()).single;
    expect(row.nextAttemptAt, now.add(const Duration(seconds: 7)));
    expect(row.attempts, 1);

    await processor.drain();
    expect(await rows(), hasLength(1));
    expect(adapter.requests, hasLength(1));

    later(const Duration(seconds: 8));
    await processor.drain();
    expect(await rows(), isEmpty);
  });

  test(
    '409 version_conflict keeps the server state and offers cancel again',
    () async {
      server.update(a(), 'PAID');
      await repo.enqueueCancel(orderId: a(), ifMatchVersion: 1, reason: 'x');
      await processor.drain();

      final row = (await rows()).single;
      expect(row.state, OutboxStates.conflict);
      expect(row.snapshot?['version'], 2);
      expect((await db.ordersDao.findById(a()))?.version, 2);

      await repo.cancelAgain(row.id);
      await processor.drain();

      expect(await rows(), isEmpty);
      expect((await db.ordersDao.findById(a()))?.status, 'CANCELLED');
      expect(adapter.requests.last.headers['If-Match'], '2');
      expect(adapter.requests.last.headers['Idempotency-Key'], 'key-00000002');
    },
  );

  test('422 not_cancellable fails, is not retried, and reverts the optimistic state', () async {
    await repo.enqueueCancel(
      orderId: completed(),
      ifMatchVersion: 1,
      reason: 'x',
    );
    await processor.drain();
    later(const Duration(hours: 1));
    await processor.drain();

    final row = (await rows()).single;
    expect(row.state, OutboxStates.failed);
    expect(row.lastError, 'not_cancellable');
    expect(row.isActive, isFalse);
    expect(adapter.requests, hasLength(1));
    expect((await db.ordersDao.findById(completed()))?.status, 'COMPLETED');
  });

  test('404 fails and removes the local order', () async {
    final gone = c();
    server.remove(gone);
    await repo.enqueueNote(orderId: gone, text: 'hello');
    await processor.drain();

    expect((await rows()).single.lastError, 'order_not_found');
    expect(await db.ordersDao.findById(gone), isNull);
  });

  test('actions on the same order are sent in order', () async {
    server.failNext.add(const FakeResponse(500, {'error': 'internal_error'}));
    await repo.enqueueCancel(orderId: a(), ifMatchVersion: 1, reason: 'first');
    await repo.enqueueNote(orderId: a(), text: 'second');
    await processor.drain();

    expect(adapter.requests.single.path, endsWith('/cancel'));
    expect(await rows(), hasLength(2));

    later(const Duration(minutes: 5));
    await processor.drain();
    final paths = adapter.requests.map((r) => r.path.split('/').last).toList();
    expect(paths, ['cancel', 'cancel', 'notes']);
    expect(await rows(), isEmpty);
  });

  test('a blocked order does not hold back other orders', () async {
    await repo.enqueueCancel(
      orderId: completed(),
      ifMatchVersion: 1,
      reason: 'x',
    );
    await repo.enqueueNote(orderId: completed(), text: 'waits');
    await repo.enqueueNote(orderId: c(), text: 'goes');
    await processor.drain();

    final left = await rows();
    expect(left.map((r) => r.kind), ['cancel', 'note']);
    expect(left.every((r) => r.orderId == completed()), isTrue);
    expect(server.notesCreated, 1);
  });

  test(
    'after too many transient failures it needs the user, retry recovers',
    () async {
      processor.dispose();
      processor = makeProcessor(maxAttempts: 2);
      server.intercept = (_) => throwNetworkError();
      await repo.enqueueNote(orderId: a(), text: 'x');
      await processor.drain();
      later(const Duration(minutes: 5));
      await processor.drain();

      final failed = (await rows()).single;
      expect(failed.state, OutboxStates.failed);
      expect(failed.lastError, 'network');

      server.intercept = null;
      await repo.retry(failed.id);
      await processor.drain();
      expect(await rows(), isEmpty);
    },
  );

  test('a send interrupted by an app kill is resumed', () async {
    final id = await repo.enqueueNote(orderId: a(), text: 'x');
    await db.outboxDao.patch(
      id,
      const OutboxCompanion(state: Value(OutboxStates.sending)),
    );
    await processor.drain();
    expect(await rows(), isEmpty);
  });

  test('request_in_progress is treated as temporary', () async {
    server.failNext.add(
      const FakeResponse(
        409,
        {'error': 'request_in_progress'},
        {'retry-after': '1'},
      ),
    );
    await repo.enqueueNote(orderId: a(), text: 'x');
    await processor.drain();
    expect((await rows()).single.state, OutboxStates.pending);
  });

  test(
    'a summary written by a stale sync does not overwrite the result',
    () async {
      await repo.enqueueCancel(orderId: a(), ifMatchVersion: 1, reason: 'x');
      await processor.drain();
      final stale = server.orders[0].toJson()
        ..['status'] = 'PAID'
        ..['version'] = 1;
      expect(stale['version'], 1);
      final row = await db.ordersDao.findById(a());
      await db.ordersDao.upsertAll([
        row!.toSummary().copyWith(status: 'PAID', version: 1).toCompanion(),
      ]);
      expect((await db.ordersDao.findById(a()))?.status, 'CANCELLED');
    },
  );
}
