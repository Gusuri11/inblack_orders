import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';
import 'package:inblack_orders/features/orders/data/orders_api.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';

class OutboxProcessor {
  OutboxProcessor({
    required this._api,
    required this._db,
    this._maxAttempts = 8,
    this._backoff = const RetryPolicy(
      baseDelay: Duration(seconds: 2),
      maxDelay: Duration(minutes: 1),
    ),
    Random? random,
    DateTime Function()? clock,
  }) : _random = random ?? Random(),
       _clock = clock ?? DateTime.now;

  final OrdersApi _api;
  final AppDatabase _db;
  final int _maxAttempts;
  final RetryPolicy _backoff;
  final Random _random;
  final DateTime Function() _clock;

  Future<void>? _running;
  bool _again = false;
  Timer? _wake;
  bool _stopped = false;

  OutboxDao get _dao => _db.outboxDao;

  Future<void> drain() {
    if (_running != null) {
      _again = true;
      return _running ?? Future.value();
    }
    return _running = _drainLoop().whenComplete(() => _running = null);
  }

  Future<void> _drainLoop() async {
    await _dao.resetInterrupted();
    do {
      _again = false;
      await _drainOnce();
    } while (_again && !_stopped);
  }

  Future<void> _drainOnce() async {
    while (!_stopped) {
      final rows = await _dao.all();
      final now = _clock();
      final seen = <String>{};
      final ready = <OutboxRow>[];
      DateTime? nextWake;
      for (final row in rows) {
        if (!seen.add(row.orderId)) continue;
        if (row.needsAttention) continue;
        final at = row.nextAttemptAt;
        if (at == null || !at.isAfter(now)) {
          ready.add(row);
        } else if (nextWake == null || at.isBefore(nextWake)) {
          nextWake = at;
        }
      }
      if (ready.isEmpty) {
        _scheduleWake(nextWake);
        return;
      }
      for (final row in ready) {
        if (_stopped) return;
        final stop = await _send(row);
        if (stop) {
          _scheduleWake(await _earliestWake());
          return;
        }
      }
    }
  }

  void _scheduleWake(DateTime? at) {
    _wake?.cancel();
    if (at == null || _stopped) return;
    var wait = at.difference(_clock());
    if (wait.isNegative) wait = Duration.zero;
    _wake = Timer(wait, () => unawaited(drain()));
  }

  Future<bool> _send(OutboxRow row) async {
    await _dao.patch(
      row.id,
      OutboxCompanion(
        state: const Value(OutboxStates.sending),
        attempts: Value(row.attempts + 1),
      ),
    );
    try {
      switch (row.kind) {
        case OutboxKinds.cancel:
          final detail = await _api.cancel(
            row.orderId,
            ifMatch: row.ifMatchVersion ?? 0,
            reason: '${row.data['reason'] ?? ''}',
            idempotencyKey: row.idempotencyKey,
          );
          await _db.transaction(() async {
            await _saveDetail(detail);
            await _dao.remove(row.id);
          });
        case OutboxKinds.note:
          final note = await _api.addNote(
            row.orderId,
            text: '${row.data['text'] ?? ''}',
            idempotencyKey: row.idempotencyKey,
          );
          await _db.transaction(() async {
            await _appendNote(row.orderId, note);
            await _dao.remove(row.id);
          });
        default:
          await _markFailed(row, 'unknown_action');
      }
      return false;
    } on ApiException catch (e) {
      return await _handleFailure(row, e);
    }
  }

  Future<bool> _handleFailure(OutboxRow row, ApiException e) async {
    final attempts = row.attempts + 1;
    final transient =
        e.isNetworkError ||
        e.isServerError ||
        e.statusCode == 429 ||
        (e.statusCode == 409 && e.code == 'request_in_progress');

    if (transient) {
      if (attempts >= _maxAttempts) {
        await _markFailed(
          row,
          e.isNetworkError ? 'network' : (e.code ?? 'server'),
        );
        return false;
      }
      final delay = _backoff.delayFor(attempts, e, _random);
      await _dao.patch(
        row.id,
        OutboxCompanion(
          state: const Value(OutboxStates.pending),
          nextAttemptAt: Value(_clock().add(delay).toUtc()),
          lastError: Value(e.isNetworkError ? 'network' : e.code),
        ),
      );
      return e.isNetworkError;
    }

    if (e.statusCode == 401) {
      await _dao.patch(
        row.id,
        const OutboxCompanion(
          state: Value(OutboxStates.pending),
          lastError: Value('unauthorized'),
        ),
      );
      return true;
    }

    final current = e.body?['current'];
    final currentDetail = current is Map<String, dynamic>
        ? _parseDetail(current)
        : null;
    if (currentDetail != null) await _saveDetail(currentDetail);

    if (e.statusCode == 409 && e.code == 'version_conflict') {
      await _dao.patch(
        row.id,
        OutboxCompanion(
          state: const Value(OutboxStates.conflict),
          lastError: const Value('version_conflict'),
          serverSnapshot: Value(current is Map ? jsonEncode(current) : null),
        ),
      );
      return false;
    }

    if (e.statusCode == 404) {
      await _db.ordersDao.deleteByIds([row.orderId]);
    }
    await _markFailed(
      row,
      e.code ?? 'http_${e.statusCode}',
      snapshot: current is Map ? jsonEncode(current) : null,
    );
    return false;
  }

  static OrderDetail? _parseDetail(Map<String, dynamic> json) {
    try {
      return OrderDetail.fromJson(json);
    } on Object {
      return null;
    }
  }

  Future<DateTime?> _earliestWake() async {
    DateTime? earliest;
    for (final row in await _dao.all()) {
      final at = row.nextAttemptAt;
      if (row.isActive &&
          at != null &&
          (earliest == null || at.isBefore(earliest))) {
        earliest = at;
      }
    }
    return earliest;
  }

  Future<void> _markFailed(OutboxRow row, String code, {String? snapshot}) =>
      _dao.patch(
        row.id,
        OutboxCompanion(
          state: const Value(OutboxStates.failed),
          lastError: Value(code),
          serverSnapshot: Value(snapshot),
          nextAttemptAt: const Value(null),
        ),
      );

  Future<void> _saveDetail(OrderDetail detail) async {
    final existing = await _db.ordersDao.findDetail(detail.id);
    if (existing == null || existing.version <= detail.version) {
      await _db.ordersDao.saveDetail(
        OrderDetailsCompanion.insert(
          id: detail.id,
          json: jsonEncode(detail.toJson()),
          version: detail.version,
          fetchedAt: _clock().toUtc(),
        ),
      );
    }
    await _db.ordersDao.upsertAll([detail.toSummary().toCompanion()]);
  }

  Future<void> _appendNote(String orderId, OrderNote note) async {
    final existing = await _db.ordersDao.findDetail(orderId);
    if (existing == null) return;
    final decoded = jsonDecode(existing.json);
    if (decoded is! Map<String, dynamic>) return;
    final detail = OrderDetail.fromJson(decoded);
    if (detail.notes.any((n) => n.id == note.id)) return;
    final updated = detail.copyWith(notes: [...detail.notes, note]);
    await _db.ordersDao.saveDetail(
      OrderDetailsCompanion(
        id: Value(orderId),
        json: Value(jsonEncode(updated.toJson())),
        etag: const Value(null),
        version: Value(existing.version),
        fetchedAt: Value(_clock().toUtc()),
      ),
    );
  }

  void dispose() {
    _stopped = true;
    _wake?.cancel();
  }
}
