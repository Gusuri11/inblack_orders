import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

class OrdersRepository {
  OrdersRepository({
    required this._api,
    required this._db,
    this._retry = const RetryPolicy(maxAttempts: 3),
  });

  final OrdersApi _api;
  final AppDatabase _db;
  final RetryPolicy _retry;

  Future<OrdersPage> fetchPage({
    List<String> statuses = const [],
    String? query,
    String? cursor,
    int limit = 50,
  }) async {
    final page = await _retry.run(
      () => _api.getOrders(
        limit: limit,
        cursor: cursor,
        statuses: statuses,
        query: query,
      ),
    );
    await _db.ordersDao.upsertAll([
      for (final o in page.items) o.toCompanion(),
    ]);
    return page;
  }

  Future<OrdersSummary> summary() => _retry.run(_api.getSummary);
}
