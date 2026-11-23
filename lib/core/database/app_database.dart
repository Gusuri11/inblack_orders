import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';
import 'package:inblack_orders/core/database/sync_state_dao.dart';
import 'package:inblack_orders/core/database/tables.dart';
import 'package:inblack_orders/core/database/user_data_store.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Orders, Outbox, SyncState],
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
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
    await delete(outbox).go();
    await delete(syncState).go();
  });
}
