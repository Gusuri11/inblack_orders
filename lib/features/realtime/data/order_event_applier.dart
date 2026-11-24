import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/notifications/order_notifier.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/realtime/data/realtime_event.dart';

abstract interface class OrderEventSink {
  Future<void> onHello(Hello hello);
  Future<void> onEvent(OrderEvent event);
}

class OrderEventApplier implements OrderEventSink {
  OrderEventApplier({
    required this._db,
    required this._sync,
    this._gapDelay = const Duration(seconds: 2),
    this.onStatusChanges,
  });

  Future<void> Function(List<StatusChange> changes)? onStatusChanges;

  final AppDatabase _db;
  final Future<void> Function() _sync;
  final Duration _gapDelay;

  final Map<String, int> _deletedAt = {};
  int _maxSeq = 0;
  Timer? _gapTimer;

  @override
  Future<void> onHello(Hello hello) async {
    _maxSeq = hello.syncSeq;
    final local = (await _db.syncStateDao.read()).syncSeq;
    if (local != null && local != hello.syncSeq) await _runSync();
  }

  @override
  Future<void> onEvent(OrderEvent event) async {
    if (_maxSeq > 0 && event.seq > _maxSeq + 1) _scheduleGapFill();
    if (event.seq > _maxSeq) _maxSeq = event.seq;

    final deletedSeq = _deletedAt[event.orderId];
    switch (event) {
      case OrderDeleted(:final id, :final seq):
        _deletedAt[id] = deletedSeq == null || seq > deletedSeq
            ? seq
            : deletedSeq;
        await _db.ordersDao.deleteByIds([id]);
      case OrderUpdated():
        if (deletedSeq != null && deletedSeq > event.seq) return;
        final applied = await _db.ordersDao.applyStatusUpdate(
          id: event.id,
          status: event.status,
          version: event.version,
          updatedAt: event.updatedAt,
        );
        final notify = onStatusChanges;
        if (applied && notify != null) {
          final row = await _db.ordersDao.findById(event.id);
          try {
            await notify([
              StatusChange(
                orderId: event.id,
                status: event.status,
                version: event.version,
                productName: row?.primaryName,
              ),
            ]);
          } on Object catch (e) {
            debugPrint('notify failed: $e');
          }
        }
      case OrderCreated(:final order):
        if (deletedSeq != null && deletedSeq > event.seq) return;
        await _db.ordersDao.upsertAll([order.toCompanion()]);
    }
  }

  void _scheduleGapFill() {
    _gapTimer?.cancel();
    _gapTimer = Timer(_gapDelay, () => unawaited(_runSync()));
  }

  Future<void> _runSync() async {
    try {
      await _sync();
    } on Object {
      return;
    }
  }

  void dispose() => _gapTimer?.cancel();
}
