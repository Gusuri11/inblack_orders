import 'dart:convert';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/background/background_sync.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/home_widget/home_widget_sync.dart';
import 'package:inblack_orders/core/notifications/order_notifier.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/app_lock/app_lock.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_http_adapter.dart';
import '../helpers/fake_orders_server.dart';
import '../helpers/memory_token_storage.dart';

class _Presenter implements NotificationPresenter {
  final shown = <List<NotificationMessage>>[];
  int cancelled = 0;

  @override
  Future<void> show(
    List<NotificationMessage> messages, {
    String? groupTitle,
  }) async => shown.add(messages);

  @override
  Future<void> cancelAll() async => cancelled++;
}

class _Store implements WidgetStore {
  Map<String, String>? last;

  @override
  Future<void> save(Map<String, String> values) async => last = values;
}

class _Auth implements DeviceAuth {
  bool supported = true;
  bool result = true;
  int prompts = 0;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return result;
  }
}

final AppLocalizations _th = lookupAppLocalizations(const Locale('th'));

StatusChange _c(String id, String status, {int v = 2}) =>
    StatusChange(orderId: id, status: status, version: v, productName: 'P');

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('OrderNotifier', () {
    late _Presenter presenter;
    late bool enabled;
    String? viewing;

    OrderNotifier make() => OrderNotifier(
      db: db,
      presenter: presenter,
      enabled: () => enabled,
      strings: () => _th,
      viewing: () => viewing,
    );

    setUp(() {
      presenter = _Presenter();
      enabled = true;
      viewing = null;
    });

    test('only terminal statuses are notified, with a deep link', () async {
      await make().handle([
        _c('A', 'COMPLETED'),
        _c('B', 'IN_PROGRESS'),
        _c('C', 'REFUNDED'),
      ]);
      final shown = presenter.shown.single;
      expect(shown.map((m) => m.payload), [
        'inblack://orders/A',
        'inblack://orders/C',
      ]);
      expect(shown.first.title, _th.notifCompletedTitle);
    });

    test('the same order and version is never notified twice', () async {
      final n = make();
      await n.handle([_c('A', 'COMPLETED')]);
      await n.handle([_c('A', 'COMPLETED')]);
      await make().handle([_c('A', 'COMPLETED')]);
      expect(presenter.shown, hasLength(1));
      await n.handle([_c('A', 'REFUNDED', v: 3)]);
      expect(presenter.shown, hasLength(2));
    });

    test('more than three in one round become a single summary', () async {
      await make().handle([for (var i = 0; i < 5; i++) _c('O$i', 'COMPLETED')]);
      final shown = presenter.shown.single;
      expect(shown.single.title, _th.notifSummaryTitle(5));
      expect(shown.single.payload, 'inblack://orders');
    });

    test('the order being viewed is not notified', () async {
      viewing = 'A';
      await make().handle([_c('A', 'COMPLETED'), _c('B', 'COMPLETED')]);
      expect(presenter.shown.single.single.payload, 'inblack://orders/B');
    });

    test("the user's own pending cancellation is not notified", () async {
      await OutboxRepository(db: db)
          .enqueueCancel(orderId: 'A', ifMatchVersion: 1, reason: 'x');
      await make().handle([_c('A', 'CANCELLED')]);
      expect(presenter.shown, isEmpty);
    });

    test('disabled notifications show nothing', () async {
      enabled = false;
      await make().handle([_c('A', 'COMPLETED')]);
      expect(presenter.shown, isEmpty);
    });
  });

  test('sync engine reports server-side status changes', () async {
    final server = FakeOrdersServer(count: 5);
    final adapter = FakeHttpAdapter(server.handle);
    final changes = <StatusChange>[];
    final engine = OrderSyncEngine(
      api: OrdersApi(fakeDio(adapter)),
      db: db,
      onStatusChanges: (c) async => changes.addAll(c),
    );
    await engine.sync();
    expect(changes, isEmpty);

    server
      ..update(server.orders[0].id, 'COMPLETED')
      ..create('NEW', DateTime.utc(2030));
    await engine.sync();
    expect(changes.single.orderId, server.orders[1].id);
    expect(changes.single.status, 'COMPLETED');
  });

  test('home widget snapshot has open count and three latest orders', () async {
    await db.ordersDao.upsertAll([
      for (final (i, s) in [
        'PENDING',
        'PAID',
        'COMPLETED',
        'IN_PROGRESS',
      ].indexed)
        OrdersCompanion.insert(
          id: 'O$i',
          status: s,
          version: 1,
          totalMinor: 12345,
          primaryName: const Value('Diamond 💎'),
          createdAt: DateTime.utc(2026, 11, 1, i),
          updatedAt: DateTime.utc(2026, 11, 1, i),
        ),
    ]);
    final store = _Store();
    final sync = HomeWidgetSync(db: db, store: store);
    await sync.push(_th, 'th');
    expect(store.last?[HomeWidgetSync.keyOpenCount], '3');
    final items =
        jsonDecode(store.last?[HomeWidgetSync.keyItems] ?? '[]') as List;
    expect(items.map((e) => (e as Map)['id']), ['O3', 'O2', 'O1']);
    expect((items.first as Map)['amount'], '฿123.45');

    await sync.clear();
    expect(store.last?[HomeWidgetSync.keySignedIn], 'false');
    expect(store.last?[HomeWidgetSync.keyItems], '[]');
  });

  test('background sync skips while the app is in the foreground', () async {
    SharedPreferences.setMockInitialValues({});
    await markForeground(db, active: true);
    final ok = await runBackgroundSync(
      database: db,
      tokenStorage: MemoryTokenStorage(),
    );
    expect(ok, isTrue);
    await markForeground(db, active: false);
    final noSession = await runBackgroundSync(
      database: db,
      tokenStorage: MemoryTokenStorage(),
    );
    expect(noSession, isTrue);
  });

  group('settings', () {
    test('choices are persisted and read back', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(c.dispose);
      final n = c.read(settingsProvider.notifier);
      await n.setLanguage('en');
      await n.setTheme(ThemeMode.dark);
      await n.setNotifications(enabled: false);
      final again = readSettings(prefs);
      expect(again.languageCode, 'en');
      expect(again.themeMode, ThemeMode.dark);
      expect(again.notificationsEnabled, isFalse);
    });
  });

  group('app lock', () {
    late _Auth auth;
    late ProviderContainer c;
    var now = DateTime.utc(2026);

    Future<void> setUpLock({required bool enabled}) async {
      SharedPreferences.setMockInitialValues({'settings.app_lock': enabled});
      final prefs = await SharedPreferences.getInstance();
      auth = _Auth();
      c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceAuthProvider.overrideWithValue(auth),
        ],
      );
      addTearDown(c.dispose);
      c.read(appLockProvider.notifier).clock = () => now;
    }

    AppLockState state() => c.read(appLockProvider);
    AppLockController ctrl() => c.read(appLockProvider.notifier);

    test('locked at cold start when enabled, unlock clears it', () async {
      await setUpLock(enabled: true);
      expect(state().locked, isTrue);
      expect(await ctrl().unlock('r'), isTrue);
      expect(state().locked, isFalse);
    });

    test('locks only after more than 30 s in the background', () async {
      await setUpLock(enabled: true);
      await ctrl().unlock('r');
      ctrl().onLifecycle(AppLifecycleState.paused);
      expect(state().obscured, isTrue);
      now = now.add(const Duration(seconds: 20));
      ctrl().onLifecycle(AppLifecycleState.resumed);
      expect(state().locked, isFalse);

      ctrl().onLifecycle(AppLifecycleState.hidden);
      now = now.add(const Duration(seconds: 31));
      ctrl().onLifecycle(AppLifecycleState.resumed);
      expect(state().locked, isTrue);
      expect(state().obscured, isFalse);
    });

    test('content is hidden while inactive even when lock is off', () async {
      await setUpLock(enabled: false);
      ctrl().onLifecycle(AppLifecycleState.inactive);
      expect(state().obscured, isTrue);
      expect(state().locked, isFalse);
    });

    test('enabling requires a successful authentication', () async {
      await setUpLock(enabled: false);
      auth.result = false;
      expect(await ctrl().enable('r'), isFalse);
      expect(c.read(settingsProvider).appLockEnabled, isFalse);
      auth.result = true;
      expect(await ctrl().enable('r'), isTrue);
      expect(c.read(settingsProvider).appLockEnabled, isTrue);
    });

    test(
      'a device without passcode or biometrics falls back to sign out',
      () async {
        await setUpLock(enabled: true);
        auth.supported = false;
        expect(await ctrl().unlock('r'), isFalse);
        expect(state().cannotVerify, isTrue);
        expect(state().locked, isTrue);
      },
    );
  });
}
