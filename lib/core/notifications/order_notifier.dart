import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

class StatusChange {
  const StatusChange({
    required this.orderId,
    required this.status,
    required this.version,
    this.productName,
  });

  final String orderId;
  final String status;
  final int version;
  final String? productName;
}

class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

abstract interface class NotificationPresenter {
  Future<void> show(List<NotificationMessage> messages, {String? groupTitle});
  Future<void> cancelAll();
}

final ValueNotifier<String?> currentlyViewedOrder = ValueNotifier(null);

class OrderNotifier {
  OrderNotifier({
    required this._db,
    required this._presenter,
    required this._enabled,
    required this._strings,
    String? Function()? viewing,
    DateTime Function()? clock,
  }) : _viewing = viewing ?? (() => currentlyViewedOrder.value),
       _clock = clock ?? DateTime.now;

  static const Set<String> notifiable = {
    OrderStatuses.completed,
    OrderStatuses.cancelled,
    OrderStatuses.refunded,
  };
  static const summaryThreshold = 3;

  final AppDatabase _db;
  final NotificationPresenter _presenter;
  final bool Function() _enabled;
  final AppLocalizations Function() _strings;
  final String? Function() _viewing;
  final DateTime Function() _clock;

  Future<void> handle(List<StatusChange> changes) async {
    if (!_enabled()) return;
    final candidates = changes
        .where((c) => notifiable.contains(c.status))
        .where((c) => c.orderId != _viewing())
        .toList();
    if (candidates.isEmpty) return;

    final ownCancels = {
      for (final r in await _db.outboxDao.all())
        if (r.kind == OutboxKinds.cancel && (r.isActive)) r.orderId,
    };

    final fresh = <StatusChange>[];
    for (final c in candidates) {
      if (c.status == OrderStatuses.cancelled &&
          ownCancels.contains(c.orderId)) {
        continue;
      }
      final inserted = await _db
          .into(_db.notifiedLog)
          .insertReturningOrNull(
            NotifiedLogCompanion.insert(
              orderId: c.orderId,
              version: c.version,
              notifiedAt: _clock().toUtc(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      if (inserted != null) fresh.add(c);
    }
    if (fresh.isEmpty) return;

    final l = _strings();
    if (fresh.length > summaryThreshold) {
      await _presenter.show([
        NotificationMessage(
          id: 1,
          title: l.notifSummaryTitle(fresh.length),
          body: fresh.map((c) => c.orderId).join(', '),
          payload: 'inblack://orders',
        ),
      ], groupTitle: l.notifSummaryTitle(fresh.length));
      return;
    }
    await _presenter.show([
      for (final c in fresh)
        NotificationMessage(
          id: c.orderId.hashCode & 0x7fffffff,
          title: switch (c.status) {
            OrderStatuses.completed => l.notifCompletedTitle,
            OrderStatuses.cancelled => l.notifCancelledTitle,
            _ => l.notifRefundedTitle,
          },
          body: l.notifBody(c.orderId, c.productName ?? ''),
          payload: 'inblack://orders/${Uri.encodeComponent(c.orderId)}',
        ),
    ]);
  }
}
