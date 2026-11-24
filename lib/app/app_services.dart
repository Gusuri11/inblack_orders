import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/background/background_sync.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';
import 'package:inblack_orders/core/home_widget/home_widget_sync.dart';
import 'package:inblack_orders/core/notifications/notification_providers.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/auth/application/auth_status.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';
import 'package:inblack_orders/features/realtime/application/realtime_providers.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

final homeWidgetSyncProvider = Provider<HomeWidgetSync>(
  (ref) => HomeWidgetSync(
    db: ref.watch(appDatabaseProvider),
    store: HomeWidgetStore(),
  ),
);

final logoutProvider = Provider<LogoutService>(LogoutService.new);

class LogoutService {
  LogoutService(this._ref);

  final Ref _ref;

  Future<void> logout() async {
    final session = _ref.read(sessionManagerProvider);
    final current = await session.session();
    if (current != null) {
      try {
        await _ref
            .read(authApiProvider)
            .logout(current.refreshToken)
            .timeout(const Duration(seconds: 5));
      } on Object catch (e) {
        debugPrint('logout request failed: $e');
      }
    }
    await _ref.read(realtimeControlProvider).setEnabled(enabled: false);
    _ref.read(outboxProcessorProvider).dispose();
    await _swallow(cancelBackgroundSync);
    await _swallow(_ref.read(notificationPresenterProvider).cancelAll);
    await _ref.read(appDatabaseProvider).wipeUserData();
    await _swallow(_ref.read(homeWidgetSyncProvider).clear);
    await _swallow(clearImageCaches);
    await _ref.read(settingsProvider.notifier).resetForLogout();
    await session.clear();
    _ref
      ..invalidate(realtimeClientProvider)
      ..invalidate(outboxProcessorProvider)
      ..invalidate(orderSyncEngineProvider);
    _ref.read(authStatusProvider.notifier).signedOut();
  }

  static Future<void> _swallow(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      debugPrint('logout cleanup step failed: $e');
    }
  }
}

Future<void> clearImageCaches() async {
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
  await DefaultCacheManager().emptyCache();
}

class SessionServices extends ConsumerStatefulWidget {
  const SessionServices({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SessionServices> createState() => _SessionServicesState();
}

class _SessionServicesState extends ConsumerState<SessionServices>
    with WidgetsBindingObserver {
  Timer? _heartbeat;
  Timer? _widgetDebounce;
  StreamSubscription<Object>? _widgetSub;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.listenManual(authStatusProvider, (_, next) {
      _setActive(next.phase == AuthPhase.signedIn);
    }, fireImmediately: true);
  }

  void _setActive(bool active) {
    if (active == _active) return;
    _active = active;
    if (active) {
      unawaited(_swallow(scheduleBackgroundSync));
      _startHeartbeat();
      _startWidgetSync();
    } else {
      _heartbeat?.cancel();
      _widgetDebounce?.cancel();
      unawaited(_widgetSub?.cancel());
      _widgetSub = null;
    }
  }

  void _startHeartbeat() {
    _heartbeat?.cancel();
    void beat() => unawaited(
      _swallow(
        () => markForeground(ref.read(appDatabaseProvider), active: true),
      ),
    );
    beat();
    _heartbeat = Timer.periodic(const Duration(seconds: 60), (_) => beat());
  }

  void _startWidgetSync() {
    unawaited(_widgetSub?.cancel());
    final db = ref.read(appDatabaseProvider);
    _widgetSub = db.ordersDao
        .watchList(const OrderListFilter(), limit: 50)
        .listen((_) => _scheduleWidget());
  }

  void _scheduleWidget() {
    _widgetDebounce?.cancel();
    _widgetDebounce = Timer(const Duration(seconds: 2), () {
      if (!mounted || !_active) return;
      final settings = ref.read(settingsProvider);
      unawaited(
        _swallow(
          () => ref
              .read(homeWidgetSyncProvider)
              .push(
                lookupAppLocalizations(settings.locale),
                settings.languageCode,
              ),
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_active) return;
    final db = ref.read(appDatabaseProvider);
    if (state == AppLifecycleState.resumed) {
      _startHeartbeat();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _heartbeat?.cancel();
      unawaited(_swallow(() => markForeground(db, active: false)));
    }
  }

  static Future<void> _swallow(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      debugPrint('session service failed: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _heartbeat?.cancel();
    _widgetDebounce?.cancel();
    unawaited(_widgetSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
