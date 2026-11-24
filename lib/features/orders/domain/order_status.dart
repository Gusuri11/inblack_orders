import 'package:flutter/material.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

enum StatusTone { amber, blue, purple, green, red, teal, neutral }

class OrderStatusInfo {
  const OrderStatusInfo({
    required this.raw,
    required this.icon,
    required this.tone,
    this.known = true,
  });

  final String raw;
  final IconData icon;
  final StatusTone tone;
  final bool known;

  String label(AppLocalizations l) => switch (raw) {
    OrderStatuses.pending => l.statusPending,
    OrderStatuses.paid => l.statusPaid,
    OrderStatuses.inProgress => l.statusInProgress,
    OrderStatuses.completed => l.statusCompleted,
    OrderStatuses.cancelled => l.statusCancelled,
    OrderStatuses.refunded => l.statusRefunded,
    _ => raw,
  };
}

abstract final class OrderStatuses {
  static const pending = 'PENDING';
  static const paid = 'PAID';
  static const inProgress = 'IN_PROGRESS';
  static const completed = 'COMPLETED';
  static const cancelled = 'CANCELLED';
  static const refunded = 'REFUNDED';

  static const List<String> known = [
    pending,
    paid,
    inProgress,
    completed,
    cancelled,
    refunded,
  ];

  static const Set<String> cancellable = {pending, paid};
  static const Set<String> open = {pending, paid, inProgress};

  static OrderStatusInfo info(String raw) => switch (raw) {
    pending => const OrderStatusInfo(
      raw: pending,
      icon: Icons.hourglass_empty,
      tone: StatusTone.amber,
    ),
    paid => const OrderStatusInfo(
      raw: paid,
      icon: Icons.payments_outlined,
      tone: StatusTone.blue,
    ),
    inProgress => const OrderStatusInfo(
      raw: inProgress,
      icon: Icons.autorenew,
      tone: StatusTone.purple,
    ),
    completed => const OrderStatusInfo(
      raw: completed,
      icon: Icons.check_circle_outline,
      tone: StatusTone.green,
    ),
    cancelled => const OrderStatusInfo(
      raw: cancelled,
      icon: Icons.cancel_outlined,
      tone: StatusTone.red,
    ),
    refunded => const OrderStatusInfo(
      raw: refunded,
      icon: Icons.undo,
      tone: StatusTone.teal,
    ),
    _ => OrderStatusInfo(
      raw: raw,
      icon: Icons.help_outline,
      tone: StatusTone.neutral,
      known: false,
    ),
  };
}
