import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/outbox/data/outbox_processor.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';

final outboxRepositoryProvider = Provider<OutboxRepository>(
  (ref) => OutboxRepository(db: ref.watch(appDatabaseProvider)),
);

final outboxProcessorProvider = Provider<OutboxProcessor>((ref) {
  final processor = OutboxProcessor(
    api: ref.watch(ordersApiProvider),
    db: ref.watch(appDatabaseProvider),
  );
  ref.onDispose(processor.dispose);
  return processor;
});

final outboxItemsProvider = StreamProvider<List<OutboxRow>>(
  (ref) => ref.watch(outboxRepositoryProvider).watchAll(),
);

final outboxAttentionCountProvider = Provider<int>((ref) {
  final items = ref.watch(outboxItemsProvider).value ?? const [];
  return items.where((r) => r.needsAttention).length;
});

final outboxActionsProvider = Provider<OutboxActions>(
  (ref) => _OutboxActions(
    ref.watch(outboxRepositoryProvider),
    ref.watch(outboxProcessorProvider),
  ),
);

abstract interface class OutboxActions {
  void drain();
  Future<void> cancelOrder({
    required String orderId,
    required int version,
    required String reason,
  });
  Future<void> addNote({required String orderId, required String text});
  Future<void> retry(int id);
  Future<void> discard(int id);
  Future<void> cancelAgain(int conflictId);
}

class _OutboxActions implements OutboxActions {
  _OutboxActions(this._repo, this._processor);

  final OutboxRepository _repo;
  final OutboxProcessor _processor;

  @override
  void drain() => unawaited(_processor.drain());

  @override
  Future<void> cancelOrder({
    required String orderId,
    required int version,
    required String reason,
  }) async {
    await _repo.enqueueCancel(
      orderId: orderId,
      ifMatchVersion: version,
      reason: reason,
    );
    drain();
  }

  @override
  Future<void> addNote({required String orderId, required String text}) async {
    await _repo.enqueueNote(orderId: orderId, text: text);
    drain();
  }

  @override
  Future<void> retry(int id) async {
    await _repo.retry(id);
    drain();
  }

  @override
  Future<void> discard(int id) => _repo.discard(id);

  @override
  Future<void> cancelAgain(int conflictId) async {
    await _repo.cancelAgain(conflictId);
    drain();
  }
}

String outboxErrorMessage(String? code) => switch (code) {
  'network' => 'ส่งไม่สำเร็จเพราะเชื่อมต่อเซิร์ฟเวอร์ไม่ได้',
  'not_cancellable' => 'คำสั่งซื้อนี้ยกเลิกไม่ได้แล้ว เพราะสถานะเปลี่ยนไป',
  'order_not_found' => 'ไม่พบคำสั่งซื้อนี้แล้ว อาจถูกลบไปก่อนส่ง',
  'validation_error' => 'ข้อมูลไม่ถูกต้อง กรุณาแก้ไขแล้วลองใหม่',
  'version_conflict' => 'สถานะคำสั่งซื้อเปลี่ยนไประหว่างรอส่ง',
  'idempotency_key_reused' => 'คำขอนี้ซ้ำกับคำขอก่อนหน้า',
  'unauthorized' => 'รอเข้าสู่ระบบใหม่',
  null => 'รอส่ง',
  _ => 'ส่งไม่สำเร็จ ($code)',
};

String outboxKindLabel(String kind) => switch (kind) {
  'cancel' => 'ยกเลิกคำสั่งซื้อ',
  'note' => 'เพิ่มโน้ต',
  _ => kind,
};
