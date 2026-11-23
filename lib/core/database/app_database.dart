import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:inblack_orders/core/database/app_database.steps.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';
import 'package:inblack_orders/core/database/sync_state_dao.dart';
import 'package:inblack_orders/core/database/tables.dart';
import 'package:inblack_orders/core/database/user_data_store.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Orders, Outbox, SyncState, OrderDetails],
  daos: [OrdersDao, SyncStateDao],
)
class AppDatabase extends _$AppDatabase implements UserDataStore {
  AppDatabase(super.e);

  factory AppDatabase.open() => AppDatabase(
    driftDatabase(
      name: 'inblack_orders',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    ),
  );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.syncState, schema.syncState.oldestCreatedAt);
        await m.addColumn(schema.syncState, schema.syncState.oldestId);
        await m.database.customStatement(
          'UPDATE sync_state SET sync_seq = NULL, older_cursor = NULL, '
          'reached_end = 0',
        );
      },
      from2To3: (m, schema) async {
        await m.createTable(schema.orderDetails);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  Future<void> prepareForUser(String userId) async {
    final current = await syncStateDao.read();
    if (current.userId == userId) return;
    await wipeUserData();
    await syncStateDao.write(SyncStateCompanion(userId: Value(userId)));
  }

  Future<void> wipeUserData() => transaction(() async {
    await delete(orders).go();
    await delete(orderDetails).go();
    await delete(outbox).go();
    await delete(syncState).go();
  });
}
