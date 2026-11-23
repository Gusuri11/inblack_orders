import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/application/orders_list_controller.dart';
import 'package:inblack_orders/features/orders/application/orders_list_state.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/orders/data/orders_repository.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/fake_orders_server.dart';

Future<void> _noSleep(Duration _) async {}

const _retry = RetryPolicy(maxAttempts: 2, sleep: _noSleep);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FakeOrdersServer server;
  late FakeHttpAdapter adapter;
  late ProviderContainer container;

  ProviderContainer makeContainer() {
    final api = OrdersApi(fakeDio(adapter));
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        orderSyncEngineProvider.overrideWithValue(
          OrderSyncEngine(api: api, db: db, retry: _retry),
        ),
        ordersRepositoryProvider.overrideWithValue(
          OrdersRepository(api: api, db: db, retry: _retry),
        ),
        searchDebounceProvider.overrideWithValue(
          const Duration(milliseconds: 30),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(ordersListControllerProvider, (_, _) {});
    return c;
  }

  OrdersListState read() => container.read(ordersListControllerProvider);
  OrdersListController ctrl() =>
      container.read(ordersListControllerProvider.notifier);

  Future<void> until(
    bool Function(OrdersListState s) test, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final sw = Stopwatch()..start();
    while (!test(read())) {
      if (sw.elapsed > timeout) {
        fail('condition not met, state: ${read()}');
      }
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  Future<void> settle() => until(
    (s) =>
        s.rowsLoaded &&
        !s.syncing &&
        !s.searching &&
        s.remote != RemoteStatus.loading,
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    server = FakeOrdersServer(count: 400);
    for (var i = 0; i < server.orders.length; i++) {
      if (i % 4 == 0) server.orders[i].status = 'COMPLETED';
    }
    server.orders[3].name = 'บัตรของขวัญ Gift Card';
    server.orders[350].name = 'Gift Card เก่ามาก';
    server.orders[350].status = 'ON_HOLD';
    adapter = FakeHttpAdapter(server.handle);
  });

  tearDown(() => db.close());

  test('first open syncs then shows the first window, newest first', () async {
    container = makeContainer();
    expect(read().showInitialLoading, isTrue);
    await settle();

    expect(read().rows, hasLength(OrdersListController.pageSize));
    expect(read().rows.first.id, server.orders.first.id);
    expect(read().hasMoreLocal, isTrue);
    expect(read().summary?.total, 400);
    expect(read().lastSyncedAt, isNotNull);
  });

  test(
    'scrolling grows the window locally, then pages from the server',
    () async {
      container = makeContainer();
      await settle();
      for (var i = 0; i < 3; i++) {
        await ctrl().loadMore();
        await until((s) => s.rows.length == 100 + i * 50);
      }
      expect(read().rows, hasLength(200));
      expect(read().hasMoreLocal, isFalse);
      adapter.requests.clear();

      await ctrl().loadMore();
      await until((s) => s.rows.length == 250);

      expect(adapter.countPath('/orders'), 1);
      expect(read().rows.last.id, server.orders[249].id);
    },
  );

  test('the end of the list is reported once everything is loaded', () async {
    server = FakeOrdersServer(count: 30);
    adapter = FakeHttpAdapter(server.handle);
    container = makeContainer();
    await settle();
    expect(read().rows, hasLength(30));
    expect(read().hasMore, isFalse);
  });

  test(
    'status filter shows only matching rows and pages past the preload',
    () async {
      container = makeContainer();
      await settle();
      await ctrl().toggleStatus('COMPLETED');
      await until((s) => s.rows.length >= 50);

      expect(read().rows.every((o) => o.status == 'COMPLETED'), isTrue);
      expect(read().rows.first.id, server.orders[0].id);

      for (var i = 0; i < 20 && read().hasMore; i++) {
        await ctrl().loadMore();
        await settle();
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(read().rows, hasLength(100));
      expect(read().hasMore, isFalse);
      final expected = [
        for (final o in server.orders)
          if (o.status == 'COMPLETED') o.id,
      ];
      expect(read().rows.map((o) => o.id), expected);
    },
  );

  test('unknown statuses from the summary can be filtered', () async {
    container = makeContainer();
    await settle();
    expect(read().summary?.counts['ON_HOLD'], 1);
    await ctrl().toggleStatus('ON_HOLD');
    await until((s) => s.rows.isNotEmpty || (s.rowsLoaded && !s.hasMore));
    await settle();
    expect(read().rows.map((o) => o.id), [server.orders[350].id]);
  });

  test('search is debounced and only the last query is sent', () async {
    container = makeContainer();
    await settle();
    adapter.requests.clear();

    ctrl()
      ..setSearchText('g')
      ..setSearchText('gi')
      ..setSearchText('gift');
    await until((s) => s.activeQuery == 'gift');
    await settle();

    final searches = adapter.requests.where(
      (r) => r.path == '/orders' && r.queryParameters['q'] != null,
    );
    expect(searches.map((r) => r.queryParameters['q']), ['gift']);
    expect(read().rows.map((o) => o.id), [
      server.orders[3].id,
      server.orders[350].id,
    ]);
    expect(read().localSearch, isFalse);
  });

  test('a slow older search never overwrites the latest results', () async {
    container = makeContainer();
    await settle();
    server.delay = (r) => r.queryParameters['q'] == 'gift'
        ? const Duration(milliseconds: 300)
        : null;

    ctrl().setSearchText('gift');
    await until((s) => s.activeQuery == 'gift' && s.searching);
    ctrl().setSearchText(server.orders[10].id);
    await until((s) => s.activeQuery == server.orders[10].id);
    await settle();
    expect(read().rows.map((o) => o.id), [server.orders[10].id]);

    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(read().activeQuery, server.orders[10].id);
    expect(read().rows.map((o) => o.id), [server.orders[10].id]);
  });

  test('search while offline falls back to local data', () async {
    container = makeContainer();
    await settle();
    server.intercept = (r) =>
        r.queryParameters['q'] != null ? throwNetworkError() : null;

    ctrl().setSearchText('gift');
    await until((s) => s.activeQuery == 'gift');
    await settle();

    expect(read().localSearch, isTrue);
    expect(read().offline, isTrue);
    expect(read().showLocalResultsNotice, isTrue);
    expect(read().rows.map((o) => o.id), [server.orders[3].id]);
  });

  test('clearing the search returns to the full list', () async {
    container = makeContainer();
    await settle();
    ctrl().setSearchText('gift');
    await until((s) => s.activeQuery == 'gift');
    await settle();
    await ctrl().clearSearch();
    await settle();
    expect(read().rows, hasLength(50));
    expect(read().searchText, '');
  });

  test('refresh loads summary and changes together', () async {
    container = makeContainer();
    await settle();
    adapter.requests.clear();
    server.update(server.orders[1].id, 'REFUNDED');

    final failure = await ctrl().refresh();

    expect(failure, isNull);
    expect(adapter.countPath('/orders/summary'), 1);
    expect(adapter.countPath('/orders/changes'), 1);
    await until((s) => s.rows[1].status == 'REFUNDED');
  });

  test('refresh reports a failure without clearing the list', () async {
    container = makeContainer();
    await settle();
    server.intercept = (_) => throwNetworkError();

    final failure = await ctrl().refresh();

    expect(failure?.isNetworkError, isTrue);
    expect(read().offline, isTrue);
    expect(read().rows, isNotEmpty);
  });

  test(
    'first sync failure shows a full screen error, retry recovers',
    () async {
      server.intercept = (_) => throwNetworkError();
      container = makeContainer();
      await until((s) => s.syncError != null);
      await settle();
      expect(read().fullScreenError?.isNetworkError, isTrue);

      server.intercept = null;
      await ctrl().retry();
      await settle();
      expect(read().fullScreenError, isNull);
      expect(read().rows, hasLength(50));
      expect(read().offline, isFalse);
    },
  );

  test('new orders while scrolled are held back behind a banner', () async {
    container = makeContainer();
    await settle();
    final topBefore = read().rows.first.id;
    ctrl().setAtTop(atTop: false);

    server.create('ORD-NEW', DateTime.utc(2030));
    await container.read(orderSyncEngineProvider).sync();
    await until((s) => s.newCount == 1);

    expect(read().rows.first.id, topBefore);

    ctrl().showNewest();
    await until((s) => s.rows.first.id == 'ORD-NEW');
    expect(read().newCount, 0);
  });
}
