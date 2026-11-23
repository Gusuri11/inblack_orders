import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

class OrderNotFoundException implements Exception {
  const OrderNotFoundException(this.id);

  final String id;
}

class OrderDetailRepository {
  OrderDetailRepository({
    required this._api,
    required this._db,
    this._retry = const RetryPolicy(maxAttempts: 3),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final OrdersApi _api;
  final AppDatabase _db;
  final RetryPolicy _retry;
  final DateTime Function() _clock;

  Stream<OrderDetail?> watch(String id) =>
      _db.ordersDao.watchDetail(id).map((row) => row?.toDetail());

  Stream<OrderRow?> watchSummary(String id) => _db.ordersDao.watchById(id);

  Future<void> refresh(String id) async {
    final cached = await _db.ordersDao.findDetail(id);
    final DetailFetch result;
    try {
      result = await _retry.run(() => _api.getOrder(id, etag: cached?.etag));
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await _db.ordersDao.deleteByIds([id]);
        throw OrderNotFoundException(id);
      }
      rethrow;
    }

    final detail = result.detail;
    if (result.notModified || detail == null) {
      if (cached != null) await _db.ordersDao.touchDetail(id, _clock());
      return;
    }
    await _db.transaction(() async {
      await _db.ordersDao.saveDetail(
        OrderDetailsCompanion.insert(
          id: id,
          json: jsonEncode(detail.toJson()),
          etag: Value(result.etag),
          version: detail.version,
          fetchedAt: _clock().toUtc(),
        ),
      );
      await _db.ordersDao.upsertAll([detail.toSummary().toCompanion()]);
    });
  }
}

extension on OrderDetailRow {
  OrderDetail? toDetail() {
    try {
      final decoded = jsonDecode(this.json);
      return decoded is Map<String, dynamic>
          ? OrderDetail.fromJson(decoded)
          : null;
    } on Object {
      return null;
    }
  }
}
