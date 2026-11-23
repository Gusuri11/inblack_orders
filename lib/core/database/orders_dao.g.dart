part of 'orders_dao.dart';

mixin _$OrdersDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrdersTable get orders => attachedDatabase.orders;
  $OrderDetailsTable get orderDetails => attachedDatabase.orderDetails;
  OrdersDaoManager get managers => OrdersDaoManager(this);
}

class OrdersDaoManager {
  final _$OrdersDaoMixin _db;
  OrdersDaoManager(this._db);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db.attachedDatabase, _db.orders);
  $$OrderDetailsTableTableManager get orderDetails =>
      $$OrderDetailsTableTableManager(_db.attachedDatabase, _db.orderDetails);
}
