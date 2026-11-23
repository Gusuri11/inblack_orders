import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:uuid/uuid.dart';

class OutboxRepository {
  OutboxRepository({
    required this._db,
    DateTime Function()? clock,
    String Function()? newKey,
  }) : _clock = clock ?? DateTime.now,
       _newKey = newKey ?? const Uuid().v4;

  final AppDatabase _db;
  final DateTime Function() _clock;
  final String Function() _newKey;

  OutboxDao get _dao => _db.outboxDao;

  Stream<List<OutboxRow>> watchAll() => _dao.watchAll();

  Stream<List<OutboxRow>> watchForOrder(String orderId) =>
      _dao.watchForOrder(orderId);

  Future<int> enqueueCancel({
    required String orderId,
    required int ifMatchVersion,
    required String reason,
  }) => _dao.enqueue(
    OutboxCompanion.insert(
      orderId: orderId,
      kind: OutboxKinds.cancel,
      payload: jsonEncode({'reason': reason.trim()}),
      idempotencyKey: _newKey(),
      ifMatchVersion: Value(ifMatchVersion),
      createdAt: _clock().toUtc(),
    ),
  );

  Future<int> enqueueNote({required String orderId, required String text}) =>
      _dao.enqueue(
        OutboxCompanion.insert(
          orderId: orderId,
          kind: OutboxKinds.note,
          payload: jsonEncode({'text': text.trim()}),
          idempotencyKey: _newKey(),
          createdAt: _clock().toUtc(),
        ),
      );

  Future<void> retry(int id) => _dao.patch(
    id,
    const OutboxCompanion(
      state: Value(OutboxStates.pending),
      attempts: Value(0),
      nextAttemptAt: Value(null),
      lastError: Value(null),
    ),
  );

  Future<void> discard(int id) => _dao.remove(id);

  Future<int?> cancelAgain(int conflictId) async {
    final row = await _dao.find(conflictId);
    if (row == null || row.state != OutboxStates.conflict) return null;
    final snapshot = row.serverSnapshot;
    final version = snapshot == null
        ? null
        : (jsonDecode(snapshot) as Map<String, dynamic>)['version'];
    if (version is! num) return null;
    final reason = (jsonDecode(row.payload) as Map<String, dynamic>)['reason'];
    return await _db.transaction(() async {
      await _dao.remove(conflictId);
      return await enqueueCancel(
        orderId: row.orderId,
        ifMatchVersion: version.toInt(),
        reason: reason is String ? reason : '',
      );
    });
  }
}

extension OutboxRowX on OutboxRow {
  bool get isActive => OutboxStates.active.contains(state);

  bool get needsAttention => OutboxStates.needsAttention.contains(state);

  Map<String, dynamic> get data {
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      return const {};
    }
  }

  Map<String, dynamic>? get snapshot {
    final raw = serverSnapshot;
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }
}
