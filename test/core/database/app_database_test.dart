import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/order_key.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';

OrdersCompanion _row(
  String id, {
  int version = 1,
  String status = 'PAID',
  int minute = 0,
}) {
  final at = DateTime.utc(2026, 11, 1, 0, minute);
  return OrdersCompanion.insert(
    id: id,
    status: status,
    version: version,
    totalMinor: 100,
    createdAt: at,
    updatedAt: at,
  );
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('OrdersDao.upsertAll', () {
    test('inserts new rows', () async {
      await db.ordersDao.upsertAll([_row('A'), _row('B')]);
      expect(await db.ordersDao.watchCount().first, 2);
    });

    test('a newer version overwrites, an older one is ignored', () async {
      await db.ordersDao.upsertAll([
        _row('A', version: 3, status: 'IN_PROGRESS'),
      ]);

      await db.ordersDao.upsertAll([_row('A', version: 2)]);
      var row = await db.ordersDao.findById('A');
      expect(row?.version, 3);
      expect(row?.status, 'IN_PROGRESS');

      await db.ordersDao.upsertAll([
        _row('A', version: 4, status: 'COMPLETED'),
      ]);
      row = await db.ordersDao.findById('A');
      expect(row?.version, 4);
      expect(row?.status, 'COMPLETED');
    });

    test('the same version is applied again (idempotent replay)', () async {
      await db.ordersDao.upsertAll([_row('A', version: 2)]);
      await db.ordersDao.upsertAll([_row('A', version: 2)]);
      expect((await db.ordersDao.findById('A'))?.version, 2);
    });
  });

  test('deleteByIds removes only the given rows', () async {
    await db.ordersDao.upsertAll([_row('A'), _row('B'), _row('C')]);
    expect(await db.ordersDao.deleteByIds(['A', 'C', 'missing']), 2);
    final ids = (await db.ordersDao.watchLatest().first).map((r) => r.id);
    expect(ids, ['B']);
  });

  test(
    'watchLatest orders by createdAt desc and keeps millisecond precision',
    () async {
      final base = DateTime.utc(2026, 11, 1, 10);
      Future<void> put(String id, DateTime at) => db.ordersDao.upsertAll([
        OrdersCompanion.insert(
          id: id,
          status: 'PAID',
          version: 1,
          totalMinor: 1,
          createdAt: at,
          updatedAt: at,
        ),
      ]);
      await put('old', base);
      await put('newer', base.add(const Duration(milliseconds: 5)));
      await put('newest', base.add(const Duration(milliseconds: 9)));

      final rows = await db.ordersDao.watchLatest().first;
      expect(rows.map((r) => r.id), ['newest', 'newer', 'old']);
      expect(rows.first.createdAt, base.add(const Duration(milliseconds: 9)));
      expect(rows.first.createdAt.isUtc, isTrue);
    },
  );

  group('SyncStateDao', () {
    test('read returns an empty state before anything is written', () async {
      final s = await db.syncStateDao.read();
      expect(s.syncSeq, isNull);
      expect(s.userId, isNull);
    });

    test('write merges fields into the single row', () async {
      await db.syncStateDao.write(
        const SyncStateCompanion(userId: Value('u1')),
      );
      await db.syncStateDao.write(const SyncStateCompanion(syncSeq: Value(42)));
      final s = await db.syncStateDao.read();
      expect(s.userId, 'u1');
      expect(s.syncSeq, 42);
    });

    test('resetSyncProgress keeps the user', () async {
      await db.syncStateDao.write(
        const SyncStateCompanion(userId: Value('u1'), syncSeq: Value(9)),
      );
      await db.syncStateDao.resetSyncProgress();
      final s = await db.syncStateDao.read();
      expect(s.userId, 'u1');
      expect(s.syncSeq, isNull);
    });
  });

  group('prepareForUser', () {
    Future<void> seed(String user) async {
      await db.syncStateDao.write(
        SyncStateCompanion(userId: Value(user), syncSeq: const Value(5)),
      );
      await db.ordersDao.upsertAll([_row('A')]);
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              orderId: 'A',
              kind: 'note',
              payload: '{}',
              idempotencyKey: 'key-00000001',
              createdAt: DateTime.utc(2026),
            ),
          );
    }

    test('same user keeps local data', () async {
      await seed('u1');
      await db.prepareForUser('u1');
      expect(await db.ordersDao.watchCount().first, 1);
      expect(await db.select(db.outbox).get(), hasLength(1));
      expect((await db.syncStateDao.read()).syncSeq, 5);
    });

    test('a different user wipes orders, outbox and sync state', () async {
      await seed('u1');
      await db.prepareForUser('u2');
      expect(await db.ordersDao.watchCount().first, 0);
      expect(await db.select(db.outbox).get(), isEmpty);
      final s = await db.syncStateDao.read();
      expect(s.userId, 'u2');
      expect(s.syncSeq, isNull);
    });
  });

  group('watchList', () {
    setUp(() async {
      await db.ordersDao.upsertAll([
        for (var i = 0; i < 10; i++)
          _row('ORD-$i', minute: i, status: i.isEven ? 'PAID' : 'COMPLETED'),
        _row('ORD-X', minute: 20, status: 'ON_HOLD'),
      ]);
    });

    Future<List<String>> ids(OrderListFilter f, {int limit = 50}) async =>
        (await db.ordersDao.watchList(f, limit: limit).first)
            .map((r) => r.id)
            .toList();

    test('newest first with limit', () async {
      expect(await ids(const OrderListFilter(), limit: 3), [
        'ORD-X',
        'ORD-9',
        'ORD-8',
      ]);
    });

    test('filters by several statuses including unknown ones', () async {
      final result = await ids(
        const OrderListFilter(statuses: ['ON_HOLD', 'COMPLETED']),
      );
      expect(result, ['ORD-X', 'ORD-9', 'ORD-7', 'ORD-5', 'ORD-3', 'ORD-1']);
    });

    test('olderBound hides rows older than the loaded range', () async {
      final bound = OrderKey(DateTime.utc(2026, 11, 1, 0, 7), 'ORD-7');
      expect(await ids(OrderListFilter(olderBound: bound)), [
        'ORD-X',
        'ORD-9',
        'ORD-8',
        'ORD-7',
      ]);
    });

    test('ids restricts to a search result set', () async {
      expect(await ids(const OrderListFilter(ids: ['ORD-2', 'ORD-5'])), [
        'ORD-5',
        'ORD-2',
      ]);
    });

    test(
      'local search matches id and product name case-insensitively',
      () async {
        await db.ordersDao.upsertAll([
          OrdersCompanion.insert(
            id: 'ORD-GC',
            status: 'PAID',
            version: 1,
            totalMinor: 1,
            primaryName: const Value('Gift Card 100% บัตรของขวัญ'),
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        ]);
        expect(await ids(const OrderListFilter(search: 'gift')), ['ORD-GC']);
        expect(await ids(const OrderListFilter(search: 'ของขวัญ')), ['ORD-GC']);
        expect(await ids(const OrderListFilter(search: '100%')), ['ORD-GC']);
        expect(await ids(const OrderListFilter(search: 'ord-x')), ['ORD-X']);
        expect(await ids(const OrderListFilter(search: '_')), isEmpty);
      },
    );

    test('anchor hides newer rows and counts them separately', () async {
      final anchor = OrderKey(DateTime.utc(2026, 11, 1, 0, 8), 'ORD-8');
      final f = OrderListFilter(anchor: anchor);
      expect(await ids(f, limit: 2), ['ORD-8', 'ORD-7']);
      expect(await db.ordersDao.watchNewerThan(f, anchor).first, 2);
      expect(
        await db.ordersDao
            .watchNewerThan(
              OrderListFilter(statuses: const ['PAID'], anchor: anchor),
              anchor,
            )
            .first,
        0,
      );
    });

    test('localStatusCounts groups by raw status', () async {
      expect(await db.ordersDao.localStatusCounts(), {
        'PAID': 5,
        'COMPLETED': 5,
        'ON_HOLD': 1,
      });
    });
  });
}
