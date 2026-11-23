import 'package:inblack_orders/features/orders/data/order_models.dart';

sealed class RealtimeEvent {
  const RealtimeEvent();

  static RealtimeEvent? parse(Map<String, dynamic> json) {
    final type = json['type'];
    final seq = json['seq'];
    try {
      switch (type) {
        case 'hello':
          return Hello(
            syncSeq: (json['syncSeq'] as num?)?.toInt() ?? 0,
            heartbeatSec: (json['heartbeatSec'] as num?)?.toInt() ?? 15,
          );
        case 'order.updated':
          final order = json['order'] as Map<String, dynamic>;
          final updatedAt = order['updatedAt'] as String?;
          return OrderUpdated(
            seq: (seq as num).toInt(),
            id: order['id'] as String,
            status: order['status'] as String,
            version: (order['version'] as num).toInt(),
            updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
          );
        case 'order.created':
          return OrderCreated(
            seq: (seq as num).toInt(),
            order: OrderSummary.fromJson(json['order'] as Map<String, dynamic>),
          );
        case 'order.deleted':
          return OrderDeleted(
            seq: (seq as num).toInt(),
            id: json['id'] as String,
          );
        case 'heartbeat':
        case 'pong':
        case 'auth.ok':
          return const KeepAlive();
      }
    } on Object {
      return null;
    }
    return null;
  }
}

class Hello extends RealtimeEvent {
  const Hello({required this.syncSeq, required this.heartbeatSec});

  final int syncSeq;
  final int heartbeatSec;
}

class KeepAlive extends RealtimeEvent {
  const KeepAlive();
}

sealed class OrderEvent extends RealtimeEvent {
  const OrderEvent(this.seq);

  final int seq;

  String get orderId;
}

class OrderUpdated extends OrderEvent {
  const OrderUpdated({
    required int seq,
    required this.id,
    required this.status,
    required this.version,
    this.updatedAt,
  }) : super(seq);

  final String id;
  final String status;
  final int version;
  final DateTime? updatedAt;

  @override
  String get orderId => id;
}

class OrderCreated extends OrderEvent {
  const OrderCreated({required int seq, required this.order}) : super(seq);

  final OrderSummary order;

  @override
  String get orderId => order.id;
}

class OrderDeleted extends OrderEvent {
  const OrderDeleted({required int seq, required this.id}) : super(seq);

  final String id;

  @override
  String get orderId => id;
}
