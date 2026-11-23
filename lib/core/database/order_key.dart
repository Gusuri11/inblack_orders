import 'package:flutter/foundation.dart';

@immutable
class OrderKey {
  const OrderKey(this.createdAt, this.id);

  final DateTime createdAt;
  final String id;

  int compareTo(OrderKey other) {
    final byTime = createdAt.compareTo(other.createdAt);
    return byTime != 0 ? byTime : id.compareTo(other.id);
  }

  static OrderKey? older(OrderKey? a, OrderKey? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.compareTo(b) <= 0 ? a : b;
  }

  @override
  bool operator ==(Object other) =>
      other is OrderKey && other.createdAt == createdAt && other.id == id;

  @override
  int get hashCode => Object.hash(createdAt, id);

  @override
  String toString() => 'OrderKey(${createdAt.toIso8601String()}, $id)';
}
