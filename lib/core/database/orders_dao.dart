import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/order_key.dart';
import 'package:inblack_orders/core/database/tables.dart';

part 'orders_dao.g.dart';

class OrderListFilter {
  const OrderListFilter({
    this.statuses = const [],
    this.ids,
    this.search,
    this.olderBound,
    this.anchor,
  });

  final List<String> statuses;
  final List<String>? ids;
  final String? search;
  final OrderKey? olderBound;
  final OrderKey? anchor;

  OrderListFilter copyWithoutAnchor() => OrderListFilter(
    statuses: statuses,
    ids: ids,
    search: search,
    olderBound: olderBound,
  );
}

@DriftAccessor(tables: [Orders, OrderDetails])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.attachedDatabase);

  Future<bool> applyStatusUpdate({
    required String id,
    required String status,
    required int version,
    DateTime? updatedAt,
  }) async {
    final changed =
        await (update(orders)..where(
              (o) => o.id.equals(id) & o.version.isSmallerThanValue(version),
            ))
            .write(
              OrdersCompanion(
                status: Value(status),
                version: Value(version),
                updatedAt: updatedAt == null
                    ? const Value.absent()
                    : Value(updatedAt.toUtc()),
              ),
            );
    return changed > 0;
  }

  Stream<OrderRow?> watchById(String id) =>
      (select(orders)..where((o) => o.id.equals(id))).watchSingleOrNull();

  Stream<OrderDetailRow?> watchDetail(String id) =>
      (select(orderDetails)..where((d) => d.id.equals(id))).watchSingleOrNull();

  Future<OrderDetailRow?> findDetail(String id) =>
      (select(orderDetails)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<void> saveDetail(OrderDetailsCompanion row) =>
      into(orderDetails).insertOnConflictUpdate(row);

  Future<void> touchDetail(String id, DateTime fetchedAt) =>
      (update(orderDetails)..where((d) => d.id.equals(id))).write(
        OrderDetailsCompanion(fetchedAt: Value(fetchedAt.toUtc())),
      );

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

  Future<int> deleteByIds(Iterable<String> ids) async {
    final list = ids.toList();
    if (list.isEmpty) return 0;
    return await transaction(() async {
      await (delete(orderDetails)..where((d) => d.id.isIn(list))).go();
      return await (delete(orders)..where((o) => o.id.isIn(list))).go();
    });
  }

  Future<OrderRow?> findById(String id) =>
      (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();

  Stream<int> watchCount() {
    final count = orders.id.count();
    return (selectOnly(
      orders,
    )..addColumns([count])).map((row) => row.read(count) ?? 0).watchSingle();
  }

  Stream<List<OrderRow>> watchLatest({int limit = 50}) =>
      watchList(const OrderListFilter(), limit: limit);

  Stream<List<OrderRow>> watchList(
    OrderListFilter filter, {
    required int limit,
  }) {
    return (select(orders)
          ..where((o) => _predicate(o, filter))
          ..orderBy([
            (o) => OrderingTerm.desc(o.createdAt),
            (o) => OrderingTerm.desc(o.id),
          ])
          ..limit(limit))
        .watch();
  }

  Stream<int> watchNewerThan(OrderListFilter filter, OrderKey anchor) {
    final count = orders.id.count();
    final base = filter.copyWithoutAnchor();
    return (selectOnly(orders)
          ..addColumns([count])
          ..where(_predicate(orders, base) & _newerThan(orders, anchor)))
        .map((row) => row.read(count) ?? 0)
        .watchSingle();
  }

  Future<Map<String, int>> localStatusCounts() async {
    final count = orders.id.count();
    final rows =
        await (selectOnly(orders)
              ..addColumns([orders.status, count])
              ..groupBy([orders.status]))
            .get();
    return {
      for (final r in rows) r.read(orders.status) ?? '': r.read(count) ?? 0,
    };
  }

  Expression<bool> _predicate($OrdersTable o, OrderListFilter f) {
    final parts = <Expression<bool>>[
      if (f.statuses.isNotEmpty) o.status.isIn(f.statuses),
    ];
    final ids = f.ids;
    if (ids != null) parts.add(o.id.isIn(ids));
    final search = f.search?.trim().toLowerCase() ?? '';
    if (search.isNotEmpty) {
      final pattern = '%${_escapeLike(search)}%';
      parts.add(
        o.id.lower().like(pattern, escapeChar: r'\') |
            o.primaryName.lower().like(pattern, escapeChar: r'\'),
      );
    }
    final bound = f.olderBound;
    if (bound != null) parts.add(_atOrNewer(o, bound));
    final anchor = f.anchor;
    if (anchor != null) parts.add(_newerThan(o, anchor).not());
    return parts.isEmpty ? const Constant(true) : Expression.and(parts);
  }

  Expression<bool> _atOrNewer($OrdersTable o, OrderKey k) {
    final ms = k.createdAt.millisecondsSinceEpoch;
    return o.createdAt.isBiggerThanValue(ms) |
        (o.createdAt.equals(ms) & o.id.isBiggerOrEqualValue(k.id));
  }

  Expression<bool> _newerThan($OrdersTable o, OrderKey k) {
    final ms = k.createdAt.millisecondsSinceEpoch;
    return o.createdAt.isBiggerThanValue(ms) |
        (o.createdAt.equals(ms) & o.id.isBiggerThanValue(k.id));
  }

  static String _escapeLike(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');

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
