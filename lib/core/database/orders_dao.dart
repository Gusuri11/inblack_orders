import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/tables.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [Orders])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.attachedDatabase);

  Future<void> upsertAll(List<OrdersCompanion> rows) async {
    if (rows.isEmpty) return;
    await batch((b) {
      b.insertAll(
        orders,
        rows,
        onConflict: DoUpdate<Orders, OrderRow>.withExcluded(
          (old, excluded) => _fromExcluded(excluded),
          where: (old, excluded) =>
              old.version.isSmallerOrEqual(excluded.version),
        ),
      );
    });
  }

  Future<void> replaceAll(List<OrdersCompanion> rows) => transaction(() async {
    await delete(orders).go();
    await batch((b) => b.insertAll(orders, rows));
  });

  Future<int> deleteByIds(Iterable<String> ids) {
    final list = ids.toList();
    if (list.isEmpty) return Future.value(0);
    return (delete(orders)..where((o) => o.id.isIn(list))).go();
  }

  Future<OrderRow?> findById(String id) =>
      (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();

  Stream<int> watchCount() {
    final count = orders.id.count();
    return (selectOnly(
      orders,
    )..addColumns([count])).map((row) => row.read(count) ?? 0).watchSingle();
  }

  Stream<List<OrderRow>> watchLatest({int limit = 50}) {
    return (select(orders)
          ..orderBy([
            (o) => OrderingTerm.desc(o.createdAt),
            (o) => OrderingTerm.desc(o.id),
          ])
          ..limit(limit))
        .watch();
  }

  Insertable<OrderRow> _fromExcluded(Orders excluded) => OrdersCompanion.custom(
    status: excluded.status,
    version: excluded.version,
    totalMinor: excluded.totalMinor,
    currency: excluded.currency,
    lineCount: excluded.lineCount,
    itemCount: excluded.itemCount,
    primarySku: excluded.primarySku,
    primaryName: excluded.primaryName,
    primaryImageUrl: excluded.primaryImageUrl,
    createdAt: excluded.createdAt,
    updatedAt: excluded.updatedAt,
  );
}
