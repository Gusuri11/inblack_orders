import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/database/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('every schema version migrates to the latest', () async {
    const versions = GeneratedHelper.versions;
    for (final (i, from) in versions.indexed) {
      for (final to in versions.skip(i + 1)) {
        final schema = await verifier.schemaAt(from);
        final db = AppDatabase(schema.newConnection());
        await verifier.migrateAndValidate(db, to);
        await db.close();
      }
    }
  });

  test(
    'v1 to v2 keeps orders, outbox and user, and resets sync progress',
    () async {
      const createdMs = 1793500000123;
      const order = v1.OrdersData(
        id: 'ORD-1',
        status: 'PAID',
        version: 3,
        totalMinor: 17900,
        currency: 'THB',
        lineCount: 1,
        itemCount: 2,
        primarySku: 'DM-0520',
        primaryName: 'Diamond 💎',
        createdAt: createdMs,
        updatedAt: createdMs,
      );
      const outbox = v1.OutboxData(
        id: 1,
        orderId: 'ORD-1',
        kind: 'note',
        payload: '{"text":"hi"}',
        idempotencyKey: 'key-00000001',
        state: 'pending',
        attempts: 2,
        createdAt: createdMs,
      );
      const syncRow = v1.SyncStateData(
        id: 0,
        userId: 'u_alice',
        syncSeq: 42,
        olderCursor: 'abc',
        reachedEnd: 1,
        lastSyncedAt: createdMs,
      );

      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch
            ..insert(oldDb.orders, order)
            ..insert(oldDb.outbox, outbox)
            ..insert(oldDb.syncState, syncRow);
        },
        validateItems: (newDb) async {
          final orders = await newDb.select(newDb.orders).get();
          expect(orders.single.id, 'ORD-1');
          expect(orders.single.version, 3);
          expect(orders.single.primaryName, 'Diamond 💎');
          expect(orders.single.createdAt, createdMs);

          final queued = await newDb.select(newDb.outbox).get();
          expect(queued.single.idempotencyKey, 'key-00000001');
          expect(queued.single.attempts, 2);

          final sync = await newDb.select(newDb.syncState).getSingle();
          expect(sync.userId, 'u_alice');
          expect(sync.syncSeq, isNull);
          expect(sync.olderCursor, isNull);
          expect(sync.reachedEnd, 0);
          expect(sync.oldestCreatedAt, isNull);
          expect(sync.oldestId, isNull);
          expect(sync.lastSyncedAt, createdMs);
        },
      );
    },
  );
}
