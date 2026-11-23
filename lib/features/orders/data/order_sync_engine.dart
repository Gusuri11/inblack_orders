import 'dart:async';

import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';

class OrderSyncEngine {
  OrderSyncEngine({
    required this._api,
    required this._db,
    this._retry = const RetryPolicy(),
    this._preloadTarget = 200,
    this._pageSize = 50,
    this._changesPageSize = 500,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final OrdersApi _api;
  final AppDatabase _db;
  final RetryPolicy _retry;
  final int _preloadTarget;
  final int _pageSize;
  final int _changesPageSize;
  final DateTime Function() _clock;

  Future<void>? _running;
  Future<void>? _loadingOlder;
  Future<void> _queue = Future.value();

  Future<void> sync() {
    return _running ??= _serial(_sync).whenComplete(() => _running = null);
  }

  Future<void> loadOlder() {
    return _loadingOlder ??= _serial(_loadOlder)
        .whenComplete(() => _loadingOlder = null);
  }

  Future<void> _serial(Future<void> Function() task) {
    final next = _queue.then((_) => task());
    _queue = next.then<void>((_) {}, onError: (Object _) {});
    return next;
  }

  Future<void> _loadOlder() async {
    final state = await _db.syncStateDao.read();
    if (state.reachedEnd) return;
    final cursor = state.olderCursor;
    if (state.syncSeq == null || cursor == null) {
      await _sync();
      return;
    }
    final OrdersPage page;
    try {
      page = await _retry.run(
        () => _api.getOrders(limit: _pageSize, cursor: cursor),
      );
    } on ApiException catch (e) {
      if (e.code != 'invalid_cursor') rethrow;
      await _fullSync();
      return;
    }
    final last = page.items.isEmpty ? null : page.items.last;
    await _db.transaction(() async {
      await _db.ordersDao.upsertAll([
        for (final o in page.items) o.toCompanion(),
      ]);
      await _db.syncStateDao.write(
        SyncStateCompanion(
          olderCursor: Value(page.nextCursor),
          reachedEnd: Value(page.nextCursor == null),
          oldestCreatedAt: last == null
              ? const Value.absent()
              : Value(last.createdAt.toUtc()),
          oldestId: last == null ? const Value.absent() : Value(last.id),
        ),
      );
    });
  }

  Future<void> _sync() async {
    final since = (await _db.syncStateDao.read()).syncSeq;
    if (since == null) {
      await _fullSync();
      return;
    }
    try {
      await _pullChanges(since);
    } on ApiException catch (e) {
      if (e.statusCode != 410) rethrow;
      await _fullSync();
    }
  }

  Future<void> _fullSync() async {
    final items = <OrderSummary>[];
    int? syncSeq;
    String? cursor;
    do {
      final pageCursor = cursor;
      final page = await _retry.run(
        () => _api.getOrders(limit: _pageSize, cursor: pageCursor),
      );
      syncSeq ??= page.syncSeq;
      items.addAll(page.items);
      cursor = page.nextCursor;
    } while (cursor != null && items.length < _preloadTarget);

    final seq = syncSeq;
    final last = items.isEmpty ? null : items.last;
    await _db.transaction(() async {
      await _db.ordersDao.replaceAll([for (final o in items) o.toCompanion()]);
      await _db.syncStateDao.write(
        SyncStateCompanion(
          syncSeq: Value(seq),
          olderCursor: Value(cursor),
          reachedEnd: Value(cursor == null),
          lastSyncedAt: Value(_clock().toUtc()),
          oldestCreatedAt: Value(last?.createdAt.toUtc()),
          oldestId: Value(last?.id),
        ),
      );
    });

    await _pullChanges(seq);
  }

  Future<void> _pullChanges(int since) async {
    var next = since;
    while (true) {
      final from = next;
      final page = await _retry.run(
        () => _api.getChanges(since: from, limit: _changesPageSize),
      );

      final latest = <String, OrderSummary?>{};
      for (final change in [
        ...page.changes,
      ]..sort((a, b) => a.seq.compareTo(b.seq))) {
        switch (change) {
          case OrderChange(type: 'upsert', :final order?):
            latest[order.id] = order;
          case OrderChange(type: 'delete', :final id?):
            latest[id] = null;
          default:
            break;
        }
      }

      await _db.transaction(() async {
        await _db.ordersDao.upsertAll([
          for (final o in latest.values)
            if (o != null) o.toCompanion(),
        ]);
        await _db.ordersDao.deleteByIds([
          for (final e in latest.entries)
            if (e.value == null) e.key,
        ]);
        await _db.syncStateDao.write(
          SyncStateCompanion(
            syncSeq: Value(page.nextSince),
            lastSyncedAt: Value(_clock().toUtc()),
          ),
        );
      });

      next = page.nextSince;
      if (!page.hasMore) return;
    }
  }
}
