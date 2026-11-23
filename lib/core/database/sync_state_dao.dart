import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/order_key.dart';
import 'package:inblack_orders/core/database/tables.dart';

part 'sync_state_dao.g.dart';

@DriftAccessor(tables: [SyncState])
class SyncStateDao extends DatabaseAccessor<AppDatabase>
    with _$SyncStateDaoMixin {
  SyncStateDao(super.attachedDatabase);

  static const _rowId = 0;

  static const empty = SyncStateRow(id: _rowId, reachedEnd: false);

  Future<SyncStateRow> read() async =>
      await (select(
        syncState,
      )..where((s) => s.id.equals(_rowId))).getSingleOrNull() ??
      empty;

  Stream<SyncStateRow> watch() =>
      (select(syncState)..where((s) => s.id.equals(_rowId)))
          .watchSingleOrNull()
          .map((row) => row ?? empty);

  Future<void> write(SyncStateCompanion changes) async {
    await into(syncState).insert(
      changes.copyWith(id: const Value(_rowId)),
      onConflict: DoUpdate((_) => changes.copyWith(id: const Value.absent())),
    );
  }

  Future<void> resetSyncProgress() => write(
    const SyncStateCompanion(
      syncSeq: Value(null),
      olderCursor: Value(null),
      reachedEnd: Value(false),
      lastSyncedAt: Value(null),
      oldestCreatedAt: Value(null),
      oldestId: Value(null),
    ),
  );
}

extension SyncStateRowX on SyncStateRow {
  OrderKey? get oldestKey {
    final at = oldestCreatedAt;
    final id = oldestId;
    return at == null || id == null ? null : OrderKey(at, id);
  }
}
