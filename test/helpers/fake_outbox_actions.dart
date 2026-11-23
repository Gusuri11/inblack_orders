import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';

class FakeOutboxActions implements OutboxActions {
  final calls = <String>[];

  @override
  void drain() => calls.add('drain');

  @override
  Future<void> cancelOrder({
    required String orderId,
    required int version,
    required String reason,
  }) async => calls.add('cancel:$orderId:$version:$reason');

  @override
  Future<void> addNote({required String orderId, required String text}) async =>
      calls.add('note:$orderId:$text');

  @override
  Future<void> retry(int id) async => calls.add('retry:$id');

  @override
  Future<void> discard(int id) async => calls.add('discard:$id');

  @override
  Future<void> cancelAgain(int conflictId) async =>
      calls.add('again:$conflictId');
}
