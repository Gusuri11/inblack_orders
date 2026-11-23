import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/realtime/data/order_event_applier.dart';
import 'package:inblack_orders/features/realtime/data/realtime_event.dart';

OrderSummary _summary(
  String id, {
  int version = 1,
  String status = 'PENDING',
}) => OrderSummary(
  id: id,
  status: status,
  version: version,
  totalMinor: 100,
  createdAt: DateTime.utc(2026, 11),
  updatedAt: DateTime.utc(2026, 11),
);

void main() {
  late AppDatabase db;
  late OrderEventApplier applier;
  late int syncCalls;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    syncCalls = 0;
    applier = OrderEventApplier(
      db: db,
      sync: () async => syncCalls++,
      gapDelay: const Duration(milliseconds: 20),
    );
    await db.ordersDao.upsertAll([
      OrdersCompanion.insert(
        id: 'A',
        status: 'PAID',
        version: 2,
        totalMinor: 100,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    ]);
    await db.syncStateDao.write(const SyncStateCompanion(syncSeq: Value(10)));
  });

  tearDown(() {
    applier.dispose();
    return db.close();
  });

  Future<OrderRow?> row(String id) => db.ordersDao.findById(id);

  OrderUpdated updated(int seq, int version, String status) =>
      OrderUpdated(seq: seq, id: 'A', status: status, version: version);

  test('a newer version is applied', () async {
    await applier.onEvent(updated(11, 3, 'IN_PROGRESS'));
    expect((await row('A'))?.status, 'IN_PROGRESS');
    expect((await row('A'))?.version, 3);
  });

  test('out of order: the older event arriving later is ignored', () async {
    await applier.onEvent(updated(12, 4, 'COMPLETED'));
    await applier.onEvent(updated(11, 3, 'IN_PROGRESS'));
    expect((await row('A'))?.status, 'COMPLETED');
    expect((await row('A'))?.version, 4);
  });

  test('duplicates are harmless', () async {
    await applier.onEvent(updated(11, 3, 'IN_PROGRESS'));
    await applier.onEvent(updated(11, 3, 'IN_PROGRESS'));
    expect((await row('A'))?.version, 3);
  });

  test('an update for an order we do not have is ignored', () async {
    await applier.onEvent(
      const OrderUpdated(seq: 11, id: 'ZZZ', status: 'PAID', version: 5),
    );
    expect(await row('ZZZ'), isNull);
  });

  test('created inserts the order', () async {
    await applier.onEvent(OrderCreated(seq: 11, order: _summary('NEW')));
    expect((await row('NEW'))?.status, 'PENDING');
  });

  test('a deleted order is not resurrected by late events', () async {
    await applier.onEvent(const OrderDeleted(seq: 13, id: 'A'));
    await applier.onEvent(updated(12, 3, 'IN_PROGRESS'));
    await applier.onEvent(OrderCreated(seq: 11, order: _summary('A')));
    expect(await row('A'), isNull);
  });

  test('hello with a different syncSeq fills the gap via sync', () async {
    await applier.onHello(const Hello(syncSeq: 15, heartbeatSec: 15));
    expect(syncCalls, 1);
  });

  test('hello at the same syncSeq does not sync', () async {
    await applier.onHello(const Hello(syncSeq: 10, heartbeatSec: 15));
    expect(syncCalls, 0);
  });

  test('a missing seq schedules a single debounced sync', () async {
    await applier.onHello(const Hello(syncSeq: 10, heartbeatSec: 15));
    await applier.onEvent(updated(13, 3, 'IN_PROGRESS'));
    await applier.onEvent(updated(15, 4, 'COMPLETED'));
    expect(syncCalls, 0);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(syncCalls, 1);
  });

  test('contiguous seqs do not trigger a sync', () async {
    await applier.onHello(const Hello(syncSeq: 10, heartbeatSec: 15));
    await applier.onEvent(updated(11, 3, 'IN_PROGRESS'));
    await applier.onEvent(updated(12, 4, 'COMPLETED'));
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(syncCalls, 0);
  });
}
