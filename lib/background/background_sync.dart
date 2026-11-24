import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/home_widget/home_widget_sync.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/core/notifications/local_notifications.dart';
import 'package:inblack_orders/core/notifications/order_notifier.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/auth_interceptor.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/outbox/data/outbox_processor.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const backgroundTaskName = 'inblack.sync';
const backgroundUniqueName = 'inblack-periodic-sync';
const foregroundLease = Duration(seconds: 90);

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await runBackgroundSync();
  });
}

bool get _supported => Platform.isAndroid || Platform.isIOS;

Future<void> initBackgroundSync() async {
  if (!_supported) return;
  await Workmanager().initialize(callbackDispatcher);
}

Future<void> scheduleBackgroundSync() async {
  if (!_supported) return;
  await Workmanager().registerPeriodicTask(
    backgroundUniqueName,
    backgroundTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(minutes: 1),
  );
}

Future<void> cancelBackgroundSync() async {
  if (!_supported) return;
  await Workmanager().cancelAll();
}

Future<bool> runBackgroundSync({
  AppDatabase? database,
  TokenStorage? tokenStorage,
  DateTime Function() clock = DateTime.now,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final settings = readSettings(prefs);
  final strings = lookupAppLocalizations(settings.locale);
  final db = database ?? AppDatabase.open();
  try {
    final state = await db.syncStateDao.read();
    final until = state.foregroundUntil;
    if (until != null && until.isAfter(clock())) return true;

    final baseUrl =
        (AppConfig.isDev ? settings.baseUrlOverride : null) ??
        AppConfig.baseUrl;
    final session = SessionManager(
      api: AuthApi(createDio(baseUrl: baseUrl)),
      storage: tokenStorage ?? SecureTokenStorage(),
    );
    if (await session.session() == null) return true;

    final dio = createDio(baseUrl: baseUrl);
    dio.interceptors.add(AuthInterceptor(session: session, retryDio: dio));
    final api = OrdersApi(dio);

    final processor = OutboxProcessor(api: api, db: db);
    await processor.drain();
    processor.dispose();

    final presenter = LocalNotificationPresenter(
      channelName: strings.notifChannel,
    );
    final notifier = OrderNotifier(
      db: db,
      presenter: presenter,
      enabled: () => settings.notificationsEnabled,
      strings: () => strings,
      viewing: () => null,
    );
    await OrderSyncEngine(
      api: api,
      db: db,
      onStatusChanges: notifier.handle,
    ).sync();

    await HomeWidgetSync(
      db: db,
      store: HomeWidgetStore(),
    ).push(strings, settings.languageCode);
    await session.dispose();
    return true;
  } on Object catch (e) {
    debugPrint('background sync failed: $e');
    return false;
  } finally {
    if (database == null) await db.close();
  }
}

Future<void> markForeground(AppDatabase db, {required bool active}) =>
    db.syncStateDao.write(
      SyncStateCompanion(
        foregroundUntil: Value(
          active ? DateTime.now().add(foregroundLease).toUtc() : null,
        ),
      ),
    );
