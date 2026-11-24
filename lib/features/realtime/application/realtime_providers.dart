import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/connectivity/network_status.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/network/dio_factory.dart';
import 'package:inblack_orders/core/network/network_providers.dart';
import 'package:inblack_orders/core/notifications/notification_providers.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/realtime/data/order_event_applier.dart';
import 'package:inblack_orders/features/realtime/data/realtime_client.dart';
import 'package:inblack_orders/features/realtime/data/realtime_socket.dart';

abstract interface class RealtimeControl {
  Future<void> setEnabled({required bool enabled});
  void setForeground({required bool foreground});
}

class _ClientControl implements RealtimeControl {
  _ClientControl(this._client);

  final RealtimeClient _client;

  @override
  Future<void> setEnabled({required bool enabled}) =>
      _client.setEnabled(enabled: enabled);

  @override
  void setForeground({required bool foreground}) =>
      _client.setForeground(foreground: foreground);
}

final realtimeClientProvider = Provider<RealtimeClient>((ref) {
  final engine = ref.watch(orderSyncEngineProvider);
  final applier = OrderEventApplier(
    db: ref.watch(appDatabaseProvider),
    sync: engine.sync,
    onStatusChanges: ref.watch(orderNotifierProvider).handle,
  );
  final dio = ref.watch(authenticatedDioProvider);
  final client = RealtimeClient(
    baseUrl: Uri.parse(ref.watch(baseUrlProvider)),
    session: ref.watch(sessionManagerProvider),
    sink: applier,
    connector: ChannelSocket.new,
    network: ref.watch(networkStatusProvider),
    verifySession: () async {
      try {
        await dio.get<dynamic>('/me');
      } on DioException catch (e) {
        throw toApiException(e);
      }
    },
  );
  ref.onDispose(() {
    applier.dispose();
    unawaited(client.dispose());
  });
  return client;
});

final realtimeControlProvider = Provider<RealtimeControl>(
  (ref) => _ClientControl(ref.watch(realtimeClientProvider)),
);

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) async* {
  final client = ref.watch(realtimeClientProvider);
  yield client.current;
  yield* client.status;
});
