import 'package:drift/drift.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';

extension OrderSummaryToRow on OrderSummary {
  OrdersCompanion toCompanion() => OrdersCompanion.insert(
    id: id,
    status: status,
    version: version,
    totalMinor: totalMinor,
    currency: Value(currency),
    lineCount: Value(lineCount),
    itemCount: Value(itemCount),
    primarySku: Value(primaryItem?.sku),
    primaryName: Value(primaryItem?.name),
    primaryImageUrl: Value(primaryItem?.imageUrl),
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension OrderRowToSummary on OrderRow {
  OrderSummary toSummary() {
    final sku = primarySku;
    final name = primaryName;
    return OrderSummary(
      id: id,
      status: status,
      version: version,
      totalMinor: totalMinor,
      currency: currency,
      lineCount: lineCount,
      itemCount: itemCount,
      primaryItem: sku == null || name == null
          ? null
          : PrimaryItem(sku: sku, name: name, imageUrl: primaryImageUrl),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
