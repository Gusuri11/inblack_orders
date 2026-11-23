import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/tables.dart';

part 'outbox_dao.g.dart';

abstract final class OutboxStates {
  static const pending = 'pending';
  static const sending = 'sending';
  static const failed = 'failed';
  static const conflict = 'conflict';

  static const List<String> active = [pending, sending];
  static const List<String> needsAttention = [failed, conflict];
}

abstract final class OutboxKinds {
  static const cancel = 'cancel';
  static const note = 'note';
}

@DriftAccessor(tables: [Outbox])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.attachedDatabase);

  Future<int> enqueue(OutboxCompanion entry) => into(outbox).insert(entry);

  Stream<List<OutboxRow>> watchAll() =>
      (select(outbox)..orderBy([(o) => OrderingTerm.asc(o.id)])).watch();

  Stream<List<OutboxRow>> watchForOrder(String orderId) =>
      (select(outbox)
            ..where((o) => o.orderId.equals(orderId))
            ..orderBy([(o) => OrderingTerm.asc(o.id)]))
          .watch();

  Future<List<OutboxRow>> all() =>
      (select(outbox)..orderBy([(o) => OrderingTerm.asc(o.id)])).get();

  Future<OutboxRow?> find(int id) =>
      (select(outbox)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<void> patch(int id, OutboxCompanion changes) =>
      (update(outbox)..where((o) => o.id.equals(id))).write(changes);

  Future<int> remove(int id) =>
      (delete(outbox)..where((o) => o.id.equals(id))).go();

  Future<void> resetInterrupted() =>
      (update(outbox)..where((o) => o.state.equals(OutboxStates.sending)))
          .write(const OutboxCompanion(state: Value(OutboxStates.pending)));
}
