import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/notifications/local_notifications.dart';
import 'package:inblack_orders/core/notifications/order_notifier.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

final notificationPresenterProvider = Provider<LocalNotificationPresenter>(
  (ref) => LocalNotificationPresenter(
    channelName: lookupAppLocalizations(ref.read(settingsProvider).locale)
        .notifChannel,
  ),
);

final orderNotifierProvider = Provider<OrderNotifier>(
  (ref) => OrderNotifier(
    db: ref.watch(appDatabaseProvider),
    presenter: ref.watch(notificationPresenterProvider),
    enabled: () => ref.read(settingsProvider).notificationsEnabled,
    strings: () => lookupAppLocalizations(ref.read(settingsProvider).locale),
  ),
);
