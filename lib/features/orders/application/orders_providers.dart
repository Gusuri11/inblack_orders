import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/orders/data/order_sync_engine.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(authenticatedDioProvider));
});

final orderSyncEngineProvider = Provider<OrderSyncEngine>((ref) {
  return OrderSyncEngine(
    api: ref.watch(ordersApiProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

final localOrderCountProvider = StreamProvider<int>((ref) {
  return ref.watch(appDatabaseProvider).ordersDao.watchCount();
});

final syncStateProvider = StreamProvider<SyncStateRow>((ref) {
  return ref.watch(appDatabaseProvider).syncStateDao.watch();
});
