import 'package:drift/drift.dart';

class Orders extends Table with TableInfo<Orders, OrdersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Orders(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'THB\'',
    defaultValue: const CustomExpression('\'THB\''),
  );
  late final GeneratedColumn<int> lineCount = GeneratedColumn<int>(
    'line_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> primarySku = GeneratedColumn<String>(
    'primary_sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> primaryName = GeneratedColumn<String>(
    'primary_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> primaryImageUrl = GeneratedColumn<String>(
    'primary_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    version,
    totalMinor,
    currency,
    lineCount,
    itemCount,
    primarySku,
    primaryName,
    primaryImageUrl,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      lineCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_count'],
      )!,
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
      primarySku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_sku'],
      ),
      primaryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_name'],
      ),
      primaryImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_image_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  Orders createAlias(String alias) {
    return Orders(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class OrdersData extends DataClass implements Insertable<OrdersData> {
  final String id;
  final String status;
  final int version;
  final int totalMinor;
  final String currency;
  final int lineCount;
  final int itemCount;
  final String? primarySku;
  final String? primaryName;
  final String? primaryImageUrl;
  final int createdAt;
  final int updatedAt;
  const OrdersData({
    required this.id,
    required this.status,
    required this.version,
    required this.totalMinor,
    required this.currency,
    required this.lineCount,
    required this.itemCount,
    this.primarySku,
    this.primaryName,
    this.primaryImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['version'] = Variable<int>(version);
    map['total_minor'] = Variable<int>(totalMinor);
    map['currency'] = Variable<String>(currency);
    map['line_count'] = Variable<int>(lineCount);
    map['item_count'] = Variable<int>(itemCount);
    if (!nullToAbsent || primarySku != null) {
      map['primary_sku'] = Variable<String>(primarySku);
    }
    if (!nullToAbsent || primaryName != null) {
      map['primary_name'] = Variable<String>(primaryName);
    }
    if (!nullToAbsent || primaryImageUrl != null) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      status: Value(status),
      version: Value(version),
      totalMinor: Value(totalMinor),
      currency: Value(currency),
      lineCount: Value(lineCount),
      itemCount: Value(itemCount),
      primarySku: primarySku == null && nullToAbsent
          ? const Value.absent()
          : Value(primarySku),
      primaryName: primaryName == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryName),
      primaryImageUrl: primaryImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryImageUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrdersData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersData(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      lineCount: serializer.fromJson<int>(json['lineCount']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      primarySku: serializer.fromJson<String?>(json['primarySku']),
      primaryName: serializer.fromJson<String?>(json['primaryName']),
      primaryImageUrl: serializer.fromJson<String?>(json['primaryImageUrl']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'version': serializer.toJson<int>(version),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'currency': serializer.toJson<String>(currency),
      'lineCount': serializer.toJson<int>(lineCount),
      'itemCount': serializer.toJson<int>(itemCount),
      'primarySku': serializer.toJson<String?>(primarySku),
      'primaryName': serializer.toJson<String?>(primaryName),
      'primaryImageUrl': serializer.toJson<String?>(primaryImageUrl),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  OrdersData copyWith({
    String? id,
    String? status,
    int? version,
    int? totalMinor,
    String? currency,
    int? lineCount,
    int? itemCount,
    Value<String?> primarySku = const Value.absent(),
    Value<String?> primaryName = const Value.absent(),
    Value<String?> primaryImageUrl = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => OrdersData(
    id: id ?? this.id,
    status: status ?? this.status,
    version: version ?? this.version,
    totalMinor: totalMinor ?? this.totalMinor,
    currency: currency ?? this.currency,
    lineCount: lineCount ?? this.lineCount,
    itemCount: itemCount ?? this.itemCount,
    primarySku: primarySku.present ? primarySku.value : this.primarySku,
    primaryName: primaryName.present ? primaryName.value : this.primaryName,
    primaryImageUrl: primaryImageUrl.present
        ? primaryImageUrl.value
        : this.primaryImageUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrdersData copyWithCompanion(OrdersCompanion data) {
    return OrdersData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      lineCount: data.lineCount.present ? data.lineCount.value : this.lineCount,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      primarySku: data.primarySku.present
          ? data.primarySku.value
          : this.primarySku,
      primaryName: data.primaryName.present
          ? data.primaryName.value
          : this.primaryName,
      primaryImageUrl: data.primaryImageUrl.present
          ? data.primaryImageUrl.value
          : this.primaryImageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersData(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('lineCount: $lineCount, ')
          ..write('itemCount: $itemCount, ')
          ..write('primarySku: $primarySku, ')
          ..write('primaryName: $primaryName, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    version,
    totalMinor,
    currency,
    lineCount,
    itemCount,
    primarySku,
    primaryName,
    primaryImageUrl,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersData &&
          other.id == this.id &&
          other.status == this.status &&
          other.version == this.version &&
          other.totalMinor == this.totalMinor &&
          other.currency == this.currency &&
          other.lineCount == this.lineCount &&
          other.itemCount == this.itemCount &&
          other.primarySku == this.primarySku &&
          other.primaryName == this.primaryName &&
          other.primaryImageUrl == this.primaryImageUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<OrdersData> {
  final Value<String> id;
  final Value<String> status;
  final Value<int> version;
  final Value<int> totalMinor;
  final Value<String> currency;
  final Value<int> lineCount;
  final Value<int> itemCount;
  final Value<String?> primarySku;
  final Value<String?> primaryName;
  final Value<String?> primaryImageUrl;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.lineCount = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.primarySku = const Value.absent(),
    this.primaryName = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    required String status,
    required int version,
    required int totalMinor,
    this.currency = const Value.absent(),
    this.lineCount = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.primarySku = const Value.absent(),
    this.primaryName = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       version = Value(version),
       totalMinor = Value(totalMinor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OrdersData> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<int>? version,
    Expression<int>? totalMinor,
    Expression<String>? currency,
    Expression<int>? lineCount,
    Expression<int>? itemCount,
    Expression<String>? primarySku,
    Expression<String>? primaryName,
    Expression<String>? primaryImageUrl,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (currency != null) 'currency': currency,
      if (lineCount != null) 'line_count': lineCount,
      if (itemCount != null) 'item_count': itemCount,
      if (primarySku != null) 'primary_sku': primarySku,
      if (primaryName != null) 'primary_name': primaryName,
      if (primaryImageUrl != null) 'primary_image_url': primaryImageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<int>? version,
    Value<int>? totalMinor,
    Value<String>? currency,
    Value<int>? lineCount,
    Value<int>? itemCount,
    Value<String?>? primarySku,
    Value<String?>? primaryName,
    Value<String?>? primaryImageUrl,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      version: version ?? this.version,
      totalMinor: totalMinor ?? this.totalMinor,
      currency: currency ?? this.currency,
      lineCount: lineCount ?? this.lineCount,
      itemCount: itemCount ?? this.itemCount,
      primarySku: primarySku ?? this.primarySku,
      primaryName: primaryName ?? this.primaryName,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (lineCount.present) {
      map['line_count'] = Variable<int>(lineCount.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (primarySku.present) {
      map['primary_sku'] = Variable<String>(primarySku.value);
    }
    if (primaryName.present) {
      map['primary_name'] = Variable<String>(primaryName.value);
    }
    if (primaryImageUrl.present) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('currency: $currency, ')
          ..write('lineCount: $lineCount, ')
          ..write('itemCount: $itemCount, ')
          ..write('primarySku: $primarySku, ')
          ..write('primaryName: $primaryName, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Outbox extends Table with TableInfo<Outbox, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Outbox(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  late final GeneratedColumn<int> ifMatchVersion = GeneratedColumn<int>(
    'if_match_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'pending\'',
    defaultValue: const CustomExpression('\'pending\''),
  );
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> nextAttemptAt = GeneratedColumn<int>(
    'next_attempt_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> serverSnapshot = GeneratedColumn<String>(
    'server_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    kind,
    payload,
    idempotencyKey,
    ifMatchVersion,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    serverSnapshot,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      ifMatchVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}if_match_version'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      serverSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_snapshot'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  Outbox createAlias(String alias) {
    return Outbox(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int id;
  final String orderId;
  final String kind;
  final String payload;
  final String idempotencyKey;
  final int? ifMatchVersion;
  final String state;
  final int attempts;
  final int? nextAttemptAt;
  final String? lastError;
  final String? serverSnapshot;
  final int createdAt;
  const OutboxData({
    required this.id,
    required this.orderId,
    required this.kind,
    required this.payload,
    required this.idempotencyKey,
    this.ifMatchVersion,
    required this.state,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    this.serverSnapshot,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<String>(orderId);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    if (!nullToAbsent || ifMatchVersion != null) {
      map['if_match_version'] = Variable<int>(ifMatchVersion);
    }
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<int>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || serverSnapshot != null) {
      map['server_snapshot'] = Variable<String>(serverSnapshot);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      orderId: Value(orderId),
      kind: Value(kind),
      payload: Value(payload),
      idempotencyKey: Value(idempotencyKey),
      ifMatchVersion: ifMatchVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(ifMatchVersion),
      state: Value(state),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      serverSnapshot: serverSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(serverSnapshot),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      ifMatchVersion: serializer.fromJson<int?>(json['ifMatchVersion']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<int?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      serverSnapshot: serializer.fromJson<String?>(json['serverSnapshot']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<String>(orderId),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'ifMatchVersion': serializer.toJson<int?>(ifMatchVersion),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<int?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'serverSnapshot': serializer.toJson<String?>(serverSnapshot),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  OutboxData copyWith({
    int? id,
    String? orderId,
    String? kind,
    String? payload,
    String? idempotencyKey,
    Value<int?> ifMatchVersion = const Value.absent(),
    String? state,
    int? attempts,
    Value<int?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<String?> serverSnapshot = const Value.absent(),
    int? createdAt,
  }) => OutboxData(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    kind: kind ?? this.kind,
    payload: payload ?? this.payload,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    ifMatchVersion: ifMatchVersion.present
        ? ifMatchVersion.value
        : this.ifMatchVersion,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    serverSnapshot: serverSnapshot.present
        ? serverSnapshot.value
        : this.serverSnapshot,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      ifMatchVersion: data.ifMatchVersion.present
          ? data.ifMatchVersion.value
          : this.ifMatchVersion,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      serverSnapshot: data.serverSnapshot.present
          ? data.serverSnapshot.value
          : this.serverSnapshot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('ifMatchVersion: $ifMatchVersion, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverSnapshot: $serverSnapshot, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    kind,
    payload,
    idempotencyKey,
    ifMatchVersion,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    serverSnapshot,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.kind == this.kind &&
          other.payload == this.payload &&
          other.idempotencyKey == this.idempotencyKey &&
          other.ifMatchVersion == this.ifMatchVersion &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.serverSnapshot == this.serverSnapshot &&
          other.createdAt == this.createdAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> id;
  final Value<String> orderId;
  final Value<String> kind;
  final Value<String> payload;
  final Value<String> idempotencyKey;
  final Value<int?> ifMatchVersion;
  final Value<String> state;
  final Value<int> attempts;
  final Value<int?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String?> serverSnapshot;
  final Value<int> createdAt;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.ifMatchVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.serverSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String kind,
    required String payload,
    required String idempotencyKey,
    this.ifMatchVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.serverSnapshot = const Value.absent(),
    required int createdAt,
  }) : orderId = Value(orderId),
       kind = Value(kind),
       payload = Value(payload),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<int>? id,
    Expression<String>? orderId,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<String>? idempotencyKey,
    Expression<int>? ifMatchVersion,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<int>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<String>? serverSnapshot,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (ifMatchVersion != null) 'if_match_version': ifMatchVersion,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (serverSnapshot != null) 'server_snapshot': serverSnapshot,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? orderId,
    Value<String>? kind,
    Value<String>? payload,
    Value<String>? idempotencyKey,
    Value<int?>? ifMatchVersion,
    Value<String>? state,
    Value<int>? attempts,
    Value<int?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String?>? serverSnapshot,
    Value<int>? createdAt,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      ifMatchVersion: ifMatchVersion ?? this.ifMatchVersion,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      serverSnapshot: serverSnapshot ?? this.serverSnapshot,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (ifMatchVersion.present) {
      map['if_match_version'] = Variable<int>(ifMatchVersion.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<int>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (serverSnapshot.present) {
      map['server_snapshot'] = Variable<String>(serverSnapshot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('ifMatchVersion: $ifMatchVersion, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverSnapshot: $serverSnapshot, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class SyncState extends Table with TableInfo<SyncState, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> syncSeq = GeneratedColumn<int>(
    'sync_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> olderCursor = GeneratedColumn<String>(
    'older_cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> reachedEnd = GeneratedColumn<int>(
    'reached_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (reached_end IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> oldestCreatedAt = GeneratedColumn<int>(
    'oldest_created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<String> oldestId = GeneratedColumn<String>(
    'oldest_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> foregroundUntil = GeneratedColumn<int>(
    'foreground_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    syncSeq,
    olderCursor,
    reachedEnd,
    lastSyncedAt,
    oldestCreatedAt,
    oldestId,
    foregroundUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      syncSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_seq'],
      ),
      olderCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}older_cursor'],
      ),
      reachedEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reached_end'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_synced_at'],
      ),
      oldestCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}oldest_created_at'],
      ),
      oldestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oldest_id'],
      ),
      foregroundUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}foreground_until'],
      ),
    );
  }

  @override
  SyncState createAlias(String alias) {
    return SyncState(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final int id;
  final String? userId;
  final int? syncSeq;
  final String? olderCursor;
  final int reachedEnd;
  final int? lastSyncedAt;
  final int? oldestCreatedAt;
  final String? oldestId;
  final int? foregroundUntil;
  const SyncStateData({
    required this.id,
    this.userId,
    this.syncSeq,
    this.olderCursor,
    required this.reachedEnd,
    this.lastSyncedAt,
    this.oldestCreatedAt,
    this.oldestId,
    this.foregroundUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || syncSeq != null) {
      map['sync_seq'] = Variable<int>(syncSeq);
    }
    if (!nullToAbsent || olderCursor != null) {
      map['older_cursor'] = Variable<String>(olderCursor);
    }
    map['reached_end'] = Variable<int>(reachedEnd);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    if (!nullToAbsent || oldestCreatedAt != null) {
      map['oldest_created_at'] = Variable<int>(oldestCreatedAt);
    }
    if (!nullToAbsent || oldestId != null) {
      map['oldest_id'] = Variable<String>(oldestId);
    }
    if (!nullToAbsent || foregroundUntil != null) {
      map['foreground_until'] = Variable<int>(foregroundUntil);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      syncSeq: syncSeq == null && nullToAbsent
          ? const Value.absent()
          : Value(syncSeq),
      olderCursor: olderCursor == null && nullToAbsent
          ? const Value.absent()
          : Value(olderCursor),
      reachedEnd: Value(reachedEnd),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      oldestCreatedAt: oldestCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(oldestCreatedAt),
      oldestId: oldestId == null && nullToAbsent
          ? const Value.absent()
          : Value(oldestId),
      foregroundUntil: foregroundUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(foregroundUntil),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncSeq: serializer.fromJson<int?>(json['syncSeq']),
      olderCursor: serializer.fromJson<String?>(json['olderCursor']),
      reachedEnd: serializer.fromJson<int>(json['reachedEnd']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      oldestCreatedAt: serializer.fromJson<int?>(json['oldestCreatedAt']),
      oldestId: serializer.fromJson<String?>(json['oldestId']),
      foregroundUntil: serializer.fromJson<int?>(json['foregroundUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String?>(userId),
      'syncSeq': serializer.toJson<int?>(syncSeq),
      'olderCursor': serializer.toJson<String?>(olderCursor),
      'reachedEnd': serializer.toJson<int>(reachedEnd),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'oldestCreatedAt': serializer.toJson<int?>(oldestCreatedAt),
      'oldestId': serializer.toJson<String?>(oldestId),
      'foregroundUntil': serializer.toJson<int?>(foregroundUntil),
    };
  }

  SyncStateData copyWith({
    int? id,
    Value<String?> userId = const Value.absent(),
    Value<int?> syncSeq = const Value.absent(),
    Value<String?> olderCursor = const Value.absent(),
    int? reachedEnd,
    Value<int?> lastSyncedAt = const Value.absent(),
    Value<int?> oldestCreatedAt = const Value.absent(),
    Value<String?> oldestId = const Value.absent(),
    Value<int?> foregroundUntil = const Value.absent(),
  }) => SyncStateData(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    syncSeq: syncSeq.present ? syncSeq.value : this.syncSeq,
    olderCursor: olderCursor.present ? olderCursor.value : this.olderCursor,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    oldestCreatedAt: oldestCreatedAt.present
        ? oldestCreatedAt.value
        : this.oldestCreatedAt,
    oldestId: oldestId.present ? oldestId.value : this.oldestId,
    foregroundUntil: foregroundUntil.present
        ? foregroundUntil.value
        : this.foregroundUntil,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      syncSeq: data.syncSeq.present ? data.syncSeq.value : this.syncSeq,
      olderCursor: data.olderCursor.present
          ? data.olderCursor.value
          : this.olderCursor,
      reachedEnd: data.reachedEnd.present
          ? data.reachedEnd.value
          : this.reachedEnd,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      oldestCreatedAt: data.oldestCreatedAt.present
          ? data.oldestCreatedAt.value
          : this.oldestCreatedAt,
      oldestId: data.oldestId.present ? data.oldestId.value : this.oldestId,
      foregroundUntil: data.foregroundUntil.present
          ? data.foregroundUntil.value
          : this.foregroundUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('syncSeq: $syncSeq, ')
          ..write('olderCursor: $olderCursor, ')
          ..write('reachedEnd: $reachedEnd, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('oldestCreatedAt: $oldestCreatedAt, ')
          ..write('oldestId: $oldestId, ')
          ..write('foregroundUntil: $foregroundUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    syncSeq,
    olderCursor,
    reachedEnd,
    lastSyncedAt,
    oldestCreatedAt,
    oldestId,
    foregroundUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.syncSeq == this.syncSeq &&
          other.olderCursor == this.olderCursor &&
          other.reachedEnd == this.reachedEnd &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.oldestCreatedAt == this.oldestCreatedAt &&
          other.oldestId == this.oldestId &&
          other.foregroundUntil == this.foregroundUntil);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<int> id;
  final Value<String?> userId;
  final Value<int?> syncSeq;
  final Value<String?> olderCursor;
  final Value<int> reachedEnd;
  final Value<int?> lastSyncedAt;
  final Value<int?> oldestCreatedAt;
  final Value<String?> oldestId;
  final Value<int?> foregroundUntil;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncSeq = const Value.absent(),
    this.olderCursor = const Value.absent(),
    this.reachedEnd = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.oldestCreatedAt = const Value.absent(),
    this.oldestId = const Value.absent(),
    this.foregroundUntil = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncSeq = const Value.absent(),
    this.olderCursor = const Value.absent(),
    this.reachedEnd = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.oldestCreatedAt = const Value.absent(),
    this.oldestId = const Value.absent(),
    this.foregroundUntil = const Value.absent(),
  });
  static Insertable<SyncStateData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? syncSeq,
    Expression<String>? olderCursor,
    Expression<int>? reachedEnd,
    Expression<int>? lastSyncedAt,
    Expression<int>? oldestCreatedAt,
    Expression<String>? oldestId,
    Expression<int>? foregroundUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (syncSeq != null) 'sync_seq': syncSeq,
      if (olderCursor != null) 'older_cursor': olderCursor,
      if (reachedEnd != null) 'reached_end': reachedEnd,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (oldestCreatedAt != null) 'oldest_created_at': oldestCreatedAt,
      if (oldestId != null) 'oldest_id': oldestId,
      if (foregroundUntil != null) 'foreground_until': foregroundUntil,
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<String?>? userId,
    Value<int?>? syncSeq,
    Value<String?>? olderCursor,
    Value<int>? reachedEnd,
    Value<int?>? lastSyncedAt,
    Value<int?>? oldestCreatedAt,
    Value<String?>? oldestId,
    Value<int?>? foregroundUntil,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      syncSeq: syncSeq ?? this.syncSeq,
      olderCursor: olderCursor ?? this.olderCursor,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      oldestCreatedAt: oldestCreatedAt ?? this.oldestCreatedAt,
      oldestId: oldestId ?? this.oldestId,
      foregroundUntil: foregroundUntil ?? this.foregroundUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (syncSeq.present) {
      map['sync_seq'] = Variable<int>(syncSeq.value);
    }
    if (olderCursor.present) {
      map['older_cursor'] = Variable<String>(olderCursor.value);
    }
    if (reachedEnd.present) {
      map['reached_end'] = Variable<int>(reachedEnd.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (oldestCreatedAt.present) {
      map['oldest_created_at'] = Variable<int>(oldestCreatedAt.value);
    }
    if (oldestId.present) {
      map['oldest_id'] = Variable<String>(oldestId.value);
    }
    if (foregroundUntil.present) {
      map['foreground_until'] = Variable<int>(foregroundUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('syncSeq: $syncSeq, ')
          ..write('olderCursor: $olderCursor, ')
          ..write('reachedEnd: $reachedEnd, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('oldestCreatedAt: $oldestCreatedAt, ')
          ..write('oldestId: $oldestId, ')
          ..write('foregroundUntil: $foregroundUntil')
          ..write(')'))
        .toString();
  }
}

class OrderDetails extends Table
    with TableInfo<OrderDetails, OrderDetailsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OrderDetails(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, json, etag, version, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_details';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderDetailsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderDetailsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  OrderDetails createAlias(String alias) {
    return OrderDetails(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class OrderDetailsData extends DataClass
    implements Insertable<OrderDetailsData> {
  final String id;
  final String json;
  final String? etag;
  final int version;
  final int fetchedAt;
  const OrderDetailsData({
    required this.id,
    required this.json,
    this.etag,
    required this.version,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    map['version'] = Variable<int>(version);
    map['fetched_at'] = Variable<int>(fetchedAt);
    return map;
  }

  OrderDetailsCompanion toCompanion(bool nullToAbsent) {
    return OrderDetailsCompanion(
      id: Value(id),
      json: Value(json),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      version: Value(version),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory OrderDetailsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderDetailsData(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
      etag: serializer.fromJson<String?>(json['etag']),
      version: serializer.fromJson<int>(json['version']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
      'etag': serializer.toJson<String?>(etag),
      'version': serializer.toJson<int>(version),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
    };
  }

  OrderDetailsData copyWith({
    String? id,
    String? json,
    Value<String?> etag = const Value.absent(),
    int? version,
    int? fetchedAt,
  }) => OrderDetailsData(
    id: id ?? this.id,
    json: json ?? this.json,
    etag: etag.present ? etag.value : this.etag,
    version: version ?? this.version,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  OrderDetailsData copyWithCompanion(OrderDetailsCompanion data) {
    return OrderDetailsData(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
      etag: data.etag.present ? data.etag.value : this.etag,
      version: data.version.present ? data.version.value : this.version,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderDetailsData(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('etag: $etag, ')
          ..write('version: $version, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json, etag, version, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderDetailsData &&
          other.id == this.id &&
          other.json == this.json &&
          other.etag == this.etag &&
          other.version == this.version &&
          other.fetchedAt == this.fetchedAt);
}

class OrderDetailsCompanion extends UpdateCompanion<OrderDetailsData> {
  final Value<String> id;
  final Value<String> json;
  final Value<String?> etag;
  final Value<int> version;
  final Value<int> fetchedAt;
  final Value<int> rowid;
  const OrderDetailsCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.etag = const Value.absent(),
    this.version = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderDetailsCompanion.insert({
    required String id,
    required String json,
    this.etag = const Value.absent(),
    required int version,
    required int fetchedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json),
       version = Value(version),
       fetchedAt = Value(fetchedAt);
  static Insertable<OrderDetailsData> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<String>? etag,
    Expression<int>? version,
    Expression<int>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (etag != null) 'etag': etag,
      if (version != null) 'version': version,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderDetailsCompanion copyWith({
    Value<String>? id,
    Value<String>? json,
    Value<String?>? etag,
    Value<int>? version,
    Value<int>? fetchedAt,
    Value<int>? rowid,
  }) {
    return OrderDetailsCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      etag: etag ?? this.etag,
      version: version ?? this.version,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderDetailsCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('etag: $etag, ')
          ..write('version: $version, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class NotifiedLog extends Table with TableInfo<NotifiedLog, NotifiedLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  NotifiedLog(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> notifiedAt = GeneratedColumn<int>(
    'notified_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [orderId, version, notifiedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notified_log';
  @override
  Set<GeneratedColumn> get $primaryKey => {orderId, version};
  @override
  NotifiedLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotifiedLogData(
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      notifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notified_at'],
      )!,
    );
  }

  @override
  NotifiedLog createAlias(String alias) {
    return NotifiedLog(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(order_id, version)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class NotifiedLogData extends DataClass implements Insertable<NotifiedLogData> {
  final String orderId;
  final int version;
  final int notifiedAt;
  const NotifiedLogData({
    required this.orderId,
    required this.version,
    required this.notifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['order_id'] = Variable<String>(orderId);
    map['version'] = Variable<int>(version);
    map['notified_at'] = Variable<int>(notifiedAt);
    return map;
  }

  NotifiedLogCompanion toCompanion(bool nullToAbsent) {
    return NotifiedLogCompanion(
      orderId: Value(orderId),
      version: Value(version),
      notifiedAt: Value(notifiedAt),
    );
  }

  factory NotifiedLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotifiedLogData(
      orderId: serializer.fromJson<String>(json['orderId']),
      version: serializer.fromJson<int>(json['version']),
      notifiedAt: serializer.fromJson<int>(json['notifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orderId': serializer.toJson<String>(orderId),
      'version': serializer.toJson<int>(version),
      'notifiedAt': serializer.toJson<int>(notifiedAt),
    };
  }

  NotifiedLogData copyWith({String? orderId, int? version, int? notifiedAt}) =>
      NotifiedLogData(
        orderId: orderId ?? this.orderId,
        version: version ?? this.version,
        notifiedAt: notifiedAt ?? this.notifiedAt,
      );
  NotifiedLogData copyWithCompanion(NotifiedLogCompanion data) {
    return NotifiedLogData(
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      version: data.version.present ? data.version.value : this.version,
      notifiedAt: data.notifiedAt.present
          ? data.notifiedAt.value
          : this.notifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotifiedLogData(')
          ..write('orderId: $orderId, ')
          ..write('version: $version, ')
          ..write('notifiedAt: $notifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(orderId, version, notifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotifiedLogData &&
          other.orderId == this.orderId &&
          other.version == this.version &&
          other.notifiedAt == this.notifiedAt);
}

class NotifiedLogCompanion extends UpdateCompanion<NotifiedLogData> {
  final Value<String> orderId;
  final Value<int> version;
  final Value<int> notifiedAt;
  final Value<int> rowid;
  const NotifiedLogCompanion({
    this.orderId = const Value.absent(),
    this.version = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotifiedLogCompanion.insert({
    required String orderId,
    required int version,
    required int notifiedAt,
    this.rowid = const Value.absent(),
  }) : orderId = Value(orderId),
       version = Value(version),
       notifiedAt = Value(notifiedAt);
  static Insertable<NotifiedLogData> custom({
    Expression<String>? orderId,
    Expression<int>? version,
    Expression<int>? notifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orderId != null) 'order_id': orderId,
      if (version != null) 'version': version,
      if (notifiedAt != null) 'notified_at': notifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotifiedLogCompanion copyWith({
    Value<String>? orderId,
    Value<int>? version,
    Value<int>? notifiedAt,
    Value<int>? rowid,
  }) {
    return NotifiedLogCompanion(
      orderId: orderId ?? this.orderId,
      version: version ?? this.version,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (notifiedAt.present) {
      map['notified_at'] = Variable<int>(notifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotifiedLogCompanion(')
          ..write('orderId: $orderId, ')
          ..write('version: $version, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV5 extends GeneratedDatabase {
  DatabaseAtV5(QueryExecutor e) : super(e);
  late final Orders orders = Orders(this);
  late final Outbox outbox = Outbox(this);
  late final SyncState syncState = SyncState(this);
  late final OrderDetails orderDetails = OrderDetails(this);
  late final NotifiedLog notifiedLog = NotifiedLog(this);
  late final Index ordersCreatedIdx = Index(
    'orders_created_idx',
    'CREATE INDEX orders_created_idx ON orders (created_at, id)',
  );
  late final Index ordersStatusIdx = Index(
    'orders_status_idx',
    'CREATE INDEX orders_status_idx ON orders (status)',
  );
  late final Index outboxOrderIdx = Index(
    'outbox_order_idx',
    'CREATE INDEX outbox_order_idx ON outbox (order_id, id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    orders,
    outbox,
    syncState,
    orderDetails,
    notifiedLog,
    ordersCreatedIdx,
    ordersStatusIdx,
    outboxOrderIdx,
  ];
  @override
  int get schemaVersion => 5;
}
