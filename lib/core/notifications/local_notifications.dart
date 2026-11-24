import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inblack_orders/core/notifications/order_notifier.dart';

const _channelId = 'order_updates';
const _groupKey = 'com.inblack.orders.UPDATES';

class LocalNotificationPresenter implements NotificationPresenter {
  LocalNotificationPresenter({
    required this.channelName,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final String channelName;
  final _taps = StreamController<String>.broadcast();
  bool _ready = false;

  Stream<String> get taps => _taps.stream;

  Future<void> init() async {
    if (_ready || !(Platform.isAndroid || Platform.isIOS)) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final payload = r.payload;
        if (payload != null) _taps.add(payload);
      },
    );
    _ready = true;
  }

  Future<String?> launchPayload() async {
    await init();
    if (!_ready) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details?.notificationResponse?.payload;
    }
    return null;
  }

  Future<bool> requestPermission() async {
    await init();
    if (!_ready) return false;
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  @override
  Future<void> show(
    List<NotificationMessage> messages, {
    String? groupTitle,
  }) async {
    await init();
    if (!_ready) return;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        groupKey: _groupKey,
        setAsGroupSummary: groupTitle != null,
      ),
      iOS: const DarwinNotificationDetails(threadIdentifier: _groupKey),
    );
    for (final m in messages) {
      await _plugin.show(
        id: m.id,
        title: m.title,
        body: m.body,
        notificationDetails: details,
        payload: m.payload,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await init();
    if (_ready) await _plugin.cancelAll();
  }
}
