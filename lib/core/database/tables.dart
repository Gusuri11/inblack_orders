import 'package:drift/drift.dart';

class EpochMillisConverter extends TypeConverter<DateTime, int> {
  const EpochMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}

@DataClassName('OrderRow')
@TableIndex(name: 'orders_created_idx', columns: {#createdAt, #id})
@TableIndex(name: 'orders_status_idx', columns: {#status})
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  IntColumn get version => integer()();
  IntColumn get totalMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('THB'))();
  IntColumn get lineCount => integer().withDefault(const Constant(0))();
  IntColumn get itemCount => integer().withDefault(const Constant(0))();
  TextColumn get primarySku => text().nullable()();
  TextColumn get primaryName => text().nullable()();
  TextColumn get primaryImageUrl => text().nullable()();
  IntColumn get createdAt => integer().map(const EpochMillisConverter())();
  IntColumn get updatedAt => integer().map(const EpochMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OutboxRow')
@TableIndex(name: 'outbox_order_idx', columns: {#orderId, #id})
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderId => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  TextColumn get idempotencyKey => text().unique()();
  IntColumn get ifMatchVersion => integer().nullable()();
  TextColumn get state => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get nextAttemptAt =>
      integer().map(const EpochMillisConverter()).nullable()();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAt => integer().map(const EpochMillisConverter())();
}

@DataClassName('SyncStateRow')
class SyncState extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get userId => text().nullable()();
  IntColumn get syncSeq => integer().nullable()();
  TextColumn get olderCursor => text().nullable()();
  BoolColumn get reachedEnd => boolean().withDefault(const Constant(false))();
  IntColumn get lastSyncedAt =>
      integer().map(const EpochMillisConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
