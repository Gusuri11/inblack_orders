import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/application/order_detail_controller.dart';
import 'package:inblack_orders/features/orders/data/order_detail_repository.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_orders_server.dart';

Future<void> _noSleep(Duration _) async {}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FakeOrdersServer server;
  late FakeHttpAdapter adapter;
  late OrderDetailRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    server = FakeOrdersServer(count: 5);
    server.orders.first.name = 'บัตรของขวัญ 🎁 ชื่อยาวมาก';
    adapter = FakeHttpAdapter(server.handle);
    repo = OrderDetailRepository(
      api: OrdersApi(fakeDio(adapter)),
      db: db,
      retry: const RetryPolicy(maxAttempts: 2, sleep: _noSleep),
    );
  });

  tearDown(() => db.close());

  String id() => server.orders.first.id;

  group('OrderDetailRepository', () {
    test('stores the detail and its summary', () async {
      await repo.refresh(id());
      final detail = await repo.watch(id()).first;
      expect(detail?.items.single.name, 'บัตรของขวัญ 🎁 ชื่อยาวมาก');
      expect(detail?.playerId, '51234567');
      expect((await db.ordersDao.findById(id()))?.version, 1);
      expect((await db.ordersDao.findDetail(id()))?.etag, '"v1-n0"');
    });

    test('sends If-None-Match and keeps the cache on 304', () async {
      await repo.refresh(id());
      adapter.requests.clear();
      await repo.refresh(id());
      expect(adapter.requests.single.headers['If-None-Match'], '"v1-n0"');
      expect((await repo.watch(id()).first)?.version, 1);
    });

    test('a changed order replaces the cache', () async {
      await repo.refresh(id());
      server.update(id(), 'COMPLETED');
      server.orders.first.notes.add('ช่วยตรวจสอบด้วยครับ 🙏');
      await repo.refresh(id());
      final detail = await repo.watch(id()).first;
      expect(detail?.status, 'COMPLETED');
      expect(detail?.notes.single.text, 'ช่วยตรวจสอบด้วยครับ 🙏');
    });

    test('404 removes local copies and reports not found', () async {
      await repo.refresh(id());
      final gone = id();
      server.remove(gone);
      await expectLater(
        repo.refresh(gone),
        throwsA(isA<OrderNotFoundException>()),
      );
      expect(await db.ordersDao.findById(gone), isNull);
      expect(await db.ordersDao.findDetail(gone), isNull);
    });
  });

  group('OrderDetailController', () {
    late ProviderContainer container;

    ProviderContainer make() {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          orderDetailRepositoryProvider.overrideWithValue(repo),
          refetchDelayProvider.overrideWithValue(
            const Duration(milliseconds: 10),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<OrderDetailState> until(
      String orderId,
      bool Function(OrderDetailState s) test,
    ) async {
      final provider = orderDetailControllerProvider(orderId);
      final sw = Stopwatch()..start();
      while (true) {
        final current = container.read(provider);
        if (test(current)) return current;
        if (sw.elapsed > const Duration(seconds: 5)) fail('timeout: $current');
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
    }

    test('loads and exposes the detail', () async {
      container = make()
        ..listen(orderDetailControllerProvider(id()), (_, _) {});
      final s = await until(id(), (s) => s.detail != null && !s.loading);
      expect(s.status, 'PAID');
      expect(s.notFound, isFalse);
    });

    test('unknown id shows not found', () async {
      container = make()
        ..listen(orderDetailControllerProvider('ORD-NOPE'), (_, _) {});
      final s = await until('ORD-NOPE', (s) => s.notFound);
      expect(s.detail, isNull);
      expect(s.deleted, isFalse);
    });

    test('a realtime status change updates the badge and refetches', () async {
      container = make()
        ..listen(orderDetailControllerProvider(id()), (_, _) {});
      await until(id(), (s) => s.detail != null);

      server.update(id(), 'IN_PROGRESS');
      await db.ordersDao.applyStatusUpdate(
        id: id(),
        status: 'IN_PROGRESS',
        version: 2,
      );

      await until(id(), (s) => s.status == 'IN_PROGRESS');
      final s = await until(id(), (s) => s.detail?.version == 2);
      expect(s.detail?.history.single.status, 'IN_PROGRESS');
    });

    test('deletion while viewing keeps the content and flags it', () async {
      container = make()
        ..listen(orderDetailControllerProvider(id()), (_, _) {});
      await until(id(), (s) => s.detail != null);

      await db.ordersDao.deleteByIds([id()]);

      final s = await until(id(), (s) => s.deleted);
      expect(s.detail, isNotNull);
      expect(s.notFound, isFalse);
    });

    test('offline with a cached copy shows the cache and the error', () async {
      await repo.refresh(id());
      server.intercept = (_) => throwNetworkError();
      container = make()
        ..listen(orderDetailControllerProvider(id()), (_, _) {});
      final s = await until(id(), (s) => s.error != null);
      expect(s.detail?.id, id());
      expect(s.error?.isNetworkError, isTrue);
    });
  });
}
