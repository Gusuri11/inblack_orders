import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/notifications/notification_providers.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/orders/data/orders_repository.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(authenticatedDioProvider));
});

final orderSyncEngineProvider = Provider<OrderSyncEngine>((ref) {
  return OrderSyncEngine(
    api: ref.watch(ordersApiProvider),
    db: ref.watch(appDatabaseProvider),
    onStatusChanges: ref.watch(orderNotifierProvider).handle,
  );
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(
    api: ref.watch(ordersApiProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
