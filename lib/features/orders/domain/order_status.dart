import 'package:flutter/material.dart';

enum StatusTone { amber, blue, purple, green, red, teal, neutral }

class OrderStatusInfo {
  const OrderStatusInfo({
    required this.raw,
    required this.label,
    required this.icon,
    required this.tone,
    this.known = true,
  });

  final String raw;
  final String label;
  final IconData icon;
  final StatusTone tone;
  final bool known;
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
      label: 'รอชำระเงิน',
      icon: Icons.hourglass_empty,
      tone: StatusTone.amber,
    ),
    paid => const OrderStatusInfo(
      raw: paid,
      label: 'ชำระเงินแล้ว',
      icon: Icons.payments_outlined,
      tone: StatusTone.blue,
    ),
    inProgress => const OrderStatusInfo(
      raw: inProgress,
      label: 'กำลังดำเนินการ',
      icon: Icons.autorenew,
      tone: StatusTone.purple,
    ),
    completed => const OrderStatusInfo(
      raw: completed,
      label: 'สำเร็จ',
      icon: Icons.check_circle_outline,
      tone: StatusTone.green,
    ),
    cancelled => const OrderStatusInfo(
      raw: cancelled,
      label: 'ยกเลิกแล้ว',
      icon: Icons.cancel_outlined,
      tone: StatusTone.red,
    ),
    refunded => const OrderStatusInfo(
      raw: refunded,
      label: 'คืนเงินแล้ว',
      icon: Icons.undo,
      tone: StatusTone.teal,
    ),
    _ => OrderStatusInfo(
      raw: raw,
      label: raw,
      icon: Icons.help_outline,
      tone: StatusTone.neutral,
      known: false,
    ),
  };
}
