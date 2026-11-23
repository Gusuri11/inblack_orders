
part of 'app_database.dart';

class $OrdersTable extends Orders with TableInfo<$OrdersTable, OrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('THB'),
  );
  static const VerificationMeta _lineCountMeta = const VerificationMeta(
    'lineCount',
  );
  @override
  late final GeneratedColumn<int> lineCount = GeneratedColumn<int>(
    'line_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta(
    'itemCount',
  );
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _primarySkuMeta = const VerificationMeta(
    'primarySku',
  );
  @override
  late final GeneratedColumn<String> primarySku = GeneratedColumn<String>(
    'primary_sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryNameMeta = const VerificationMeta(
    'primaryName',
  );
  @override
  late final GeneratedColumn<String> primaryName = GeneratedColumn<String>(
    'primary_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryImageUrlMeta = const VerificationMeta(
    'primaryImageUrl',
  );
  @override
  late final GeneratedColumn<String> primaryImageUrl = GeneratedColumn<String>(
    'primary_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($OrdersTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($OrdersTable.$converterupdatedAt);
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
  VerificationContext validateIntegrity(
    Insertable<OrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('line_count')) {
      context.handle(
        _lineCountMeta,
        lineCount.isAcceptableOrUnknown(data['line_count']!, _lineCountMeta),
      );
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    }
    if (data.containsKey('primary_sku')) {
      context.handle(
        _primarySkuMeta,
        primarySku.isAcceptableOrUnknown(data['primary_sku']!, _primarySkuMeta),
      );
    }
    if (data.containsKey('primary_name')) {
      context.handle(
        _primaryNameMeta,
        primaryName.isAcceptableOrUnknown(
          data['primary_name']!,
          _primaryNameMeta,
        ),
      );
    }
    if (data.containsKey('primary_image_url')) {
      context.handle(
        _primaryImageUrlMeta,
        primaryImageUrl.isAcceptableOrUnknown(
          data['primary_image_url']!,
          _primaryImageUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderRow(
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
      createdAt: $OrdersTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $OrdersTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const EpochMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const EpochMillisConverter();
}

class OrderRow extends DataClass implements Insertable<OrderRow> {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  const OrderRow({
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
    {
      map['created_at'] = Variable<int>(
        $OrdersTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $OrdersTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
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

  factory OrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderRow(
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
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
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
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrderRow copyWith({
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrderRow(
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
  OrderRow copyWithCompanion(OrdersCompanion data) {
    return OrderRow(
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
    return (StringBuffer('OrderRow(')
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
      (other is OrderRow &&
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

class OrdersCompanion extends UpdateCompanion<OrderRow> {
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
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       version = Value(version),
       totalMinor = Value(totalMinor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OrderRow> custom({
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
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
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
      map['created_at'] = Variable<int>(
        $OrdersTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $OrdersTable.$converterupdatedAt.toSql(updatedAt.value),
      );
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

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _ifMatchVersionMeta = const VerificationMeta(
    'ifMatchVersion',
  );
  @override
  late final GeneratedColumn<int> ifMatchVersion = GeneratedColumn<int>(
    'if_match_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> nextAttemptAt =
      GeneratedColumn<int>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($OutboxTable.$converternextAttemptAtn);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSnapshotMeta = const VerificationMeta(
    'serverSnapshot',
  );
  @override
  late final GeneratedColumn<String> serverSnapshot = GeneratedColumn<String>(
    'server_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($OutboxTable.$convertercreatedAt);
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
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('if_match_version')) {
      context.handle(
        _ifMatchVersionMeta,
        ifMatchVersion.isAcceptableOrUnknown(
          data['if_match_version']!,
          _ifMatchVersionMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('server_snapshot')) {
      context.handle(
        _serverSnapshotMeta,
        serverSnapshot.isAcceptableOrUnknown(
          data['server_snapshot']!,
          _serverSnapshotMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
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
      nextAttemptAt: $OutboxTable.$converternextAttemptAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}next_attempt_at'],
        ),
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      serverSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_snapshot'],
      ),
      createdAt: $OutboxTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converternextAttemptAt =
      const EpochMillisConverter();
  static TypeConverter<DateTime?, int?> $converternextAttemptAtn =
      NullAwareTypeConverter.wrap($converternextAttemptAt);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const EpochMillisConverter();
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final int id;
  final String orderId;
  final String kind;
  final String payload;
  final String idempotencyKey;
  final int? ifMatchVersion;
  final String state;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final String? serverSnapshot;
  final DateTime createdAt;
  const OutboxRow({
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
      map['next_attempt_at'] = Variable<int>(
        $OutboxTable.$converternextAttemptAtn.toSql(nextAttemptAt),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || serverSnapshot != null) {
      map['server_snapshot'] = Variable<String>(serverSnapshot);
    }
    {
      map['created_at'] = Variable<int>(
        $OutboxTable.$convertercreatedAt.toSql(createdAt),
      );
    }
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

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      ifMatchVersion: serializer.fromJson<int?>(json['ifMatchVersion']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      serverSnapshot: serializer.fromJson<String?>(json['serverSnapshot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
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
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'serverSnapshot': serializer.toJson<String?>(serverSnapshot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxRow copyWith({
    int? id,
    String? orderId,
    String? kind,
    String? payload,
    String? idempotencyKey,
    Value<int?> ifMatchVersion = const Value.absent(),
    String? state,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<String?> serverSnapshot = const Value.absent(),
    DateTime? createdAt,
  }) => OutboxRow(
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
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
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
    return (StringBuffer('OutboxRow(')
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
      (other is OutboxRow &&
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

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> id;
  final Value<String> orderId;
  final Value<String> kind;
  final Value<String> payload;
  final Value<String> idempotencyKey;
  final Value<int?> ifMatchVersion;
  final Value<String> state;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String?> serverSnapshot;
  final Value<DateTime> createdAt;
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
    required DateTime createdAt,
  }) : orderId = Value(orderId),
       kind = Value(kind),
       payload = Value(payload),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
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
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String?>? serverSnapshot,
    Value<DateTime>? createdAt,
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
      map['next_attempt_at'] = Variable<int>(
        $OutboxTable.$converternextAttemptAtn.toSql(nextAttemptAt.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (serverSnapshot.present) {
      map['server_snapshot'] = Variable<String>(serverSnapshot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $OutboxTable.$convertercreatedAt.toSql(createdAt.value),
      );
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

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncSeqMeta = const VerificationMeta(
    'syncSeq',
  );
  @override
  late final GeneratedColumn<int> syncSeq = GeneratedColumn<int>(
    'sync_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _olderCursorMeta = const VerificationMeta(
    'olderCursor',
  );
  @override
  late final GeneratedColumn<String> olderCursor = GeneratedColumn<String>(
    'older_cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reachedEndMeta = const VerificationMeta(
    'reachedEnd',
  );
  @override
  late final GeneratedColumn<bool> reachedEnd = GeneratedColumn<bool>(
    'reached_end',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reached_end" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> lastSyncedAt =
      GeneratedColumn<int>(
        'last_synced_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SyncStateTable.$converterlastSyncedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> oldestCreatedAt =
      GeneratedColumn<int>(
        'oldest_created_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SyncStateTable.$converteroldestCreatedAtn);
  static const VerificationMeta _oldestIdMeta = const VerificationMeta(
    'oldestId',
  );
  @override
  late final GeneratedColumn<String> oldestId = GeneratedColumn<String>(
    'oldest_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('sync_seq')) {
      context.handle(
        _syncSeqMeta,
        syncSeq.isAcceptableOrUnknown(data['sync_seq']!, _syncSeqMeta),
      );
    }
    if (data.containsKey('older_cursor')) {
      context.handle(
        _olderCursorMeta,
        olderCursor.isAcceptableOrUnknown(
          data['older_cursor']!,
          _olderCursorMeta,
        ),
      );
    }
    if (data.containsKey('reached_end')) {
      context.handle(
        _reachedEndMeta,
        reachedEnd.isAcceptableOrUnknown(data['reached_end']!, _reachedEndMeta),
      );
    }
    if (data.containsKey('oldest_id')) {
      context.handle(
        _oldestIdMeta,
        oldestId.isAcceptableOrUnknown(data['oldest_id']!, _oldestIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
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
        DriftSqlType.bool,
        data['${effectivePrefix}reached_end'],
      )!,
      lastSyncedAt: $SyncStateTable.$converterlastSyncedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}last_synced_at'],
        ),
      ),
      oldestCreatedAt: $SyncStateTable.$converteroldestCreatedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}oldest_created_at'],
        ),
      ),
      oldestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oldest_id'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterlastSyncedAt =
      const EpochMillisConverter();
  static TypeConverter<DateTime?, int?> $converterlastSyncedAtn =
      NullAwareTypeConverter.wrap($converterlastSyncedAt);
  static TypeConverter<DateTime, int> $converteroldestCreatedAt =
      const EpochMillisConverter();
  static TypeConverter<DateTime?, int?> $converteroldestCreatedAtn =
      NullAwareTypeConverter.wrap($converteroldestCreatedAt);
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final int id;
  final String? userId;
  final int? syncSeq;
  final String? olderCursor;
  final bool reachedEnd;
  final DateTime? lastSyncedAt;
  final DateTime? oldestCreatedAt;
  final String? oldestId;
  const SyncStateRow({
    required this.id,
    this.userId,
    this.syncSeq,
    this.olderCursor,
    required this.reachedEnd,
    this.lastSyncedAt,
    this.oldestCreatedAt,
    this.oldestId,
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
    map['reached_end'] = Variable<bool>(reachedEnd);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(
        $SyncStateTable.$converterlastSyncedAtn.toSql(lastSyncedAt),
      );
    }
    if (!nullToAbsent || oldestCreatedAt != null) {
      map['oldest_created_at'] = Variable<int>(
        $SyncStateTable.$converteroldestCreatedAtn.toSql(oldestCreatedAt),
      );
    }
    if (!nullToAbsent || oldestId != null) {
      map['oldest_id'] = Variable<String>(oldestId);
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
    );
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncSeq: serializer.fromJson<int?>(json['syncSeq']),
      olderCursor: serializer.fromJson<String?>(json['olderCursor']),
      reachedEnd: serializer.fromJson<bool>(json['reachedEnd']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      oldestCreatedAt: serializer.fromJson<DateTime?>(json['oldestCreatedAt']),
      oldestId: serializer.fromJson<String?>(json['oldestId']),
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
      'reachedEnd': serializer.toJson<bool>(reachedEnd),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'oldestCreatedAt': serializer.toJson<DateTime?>(oldestCreatedAt),
      'oldestId': serializer.toJson<String?>(oldestId),
    };
  }

  SyncStateRow copyWith({
    int? id,
    Value<String?> userId = const Value.absent(),
    Value<int?> syncSeq = const Value.absent(),
    Value<String?> olderCursor = const Value.absent(),
    bool? reachedEnd,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> oldestCreatedAt = const Value.absent(),
    Value<String?> oldestId = const Value.absent(),
  }) => SyncStateRow(
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
  );
  SyncStateRow copyWithCompanion(SyncStateCompanion data) {
    return SyncStateRow(
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('syncSeq: $syncSeq, ')
          ..write('olderCursor: $olderCursor, ')
          ..write('reachedEnd: $reachedEnd, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('oldestCreatedAt: $oldestCreatedAt, ')
          ..write('oldestId: $oldestId')
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.syncSeq == this.syncSeq &&
          other.olderCursor == this.olderCursor &&
          other.reachedEnd == this.reachedEnd &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.oldestCreatedAt == this.oldestCreatedAt &&
          other.oldestId == this.oldestId);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<int> id;
  final Value<String?> userId;
  final Value<int?> syncSeq;
  final Value<String?> olderCursor;
  final Value<bool> reachedEnd;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> oldestCreatedAt;
  final Value<String?> oldestId;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncSeq = const Value.absent(),
    this.olderCursor = const Value.absent(),
    this.reachedEnd = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.oldestCreatedAt = const Value.absent(),
    this.oldestId = const Value.absent(),
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
  });
  static Insertable<SyncStateRow> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? syncSeq,
    Expression<String>? olderCursor,
    Expression<bool>? reachedEnd,
    Expression<int>? lastSyncedAt,
    Expression<int>? oldestCreatedAt,
    Expression<String>? oldestId,
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
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<String?>? userId,
    Value<int?>? syncSeq,
    Value<String?>? olderCursor,
    Value<bool>? reachedEnd,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? oldestCreatedAt,
    Value<String?>? oldestId,
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
      map['reached_end'] = Variable<bool>(reachedEnd.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(
        $SyncStateTable.$converterlastSyncedAtn.toSql(lastSyncedAt.value),
      );
    }
    if (oldestCreatedAt.present) {
      map['oldest_created_at'] = Variable<int>(
        $SyncStateTable.$converteroldestCreatedAtn.toSql(oldestCreatedAt.value),
      );
    }
    if (oldestId.present) {
      map['oldest_id'] = Variable<String>(oldestId.value);
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
          ..write('oldestId: $oldestId')
          ..write(')'))
        .toString();
  }
}

class $OrderDetailsTable extends OrderDetails
    with TableInfo<$OrderDetailsTable, OrderDetailRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> fetchedAt =
      GeneratedColumn<int>(
        'fetched_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($OrderDetailsTable.$converterfetchedAt);
  @override
  List<GeneratedColumn> get $columns => [id, json, etag, version, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderDetailRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderDetailRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderDetailRow(
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
      fetchedAt: $OrderDetailsTable.$converterfetchedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}fetched_at'],
        )!,
      ),
    );
  }

  @override
  $OrderDetailsTable createAlias(String alias) {
    return $OrderDetailsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterfetchedAt =
      const EpochMillisConverter();
}

class OrderDetailRow extends DataClass implements Insertable<OrderDetailRow> {
  final String id;
  final String json;
  final String? etag;
  final int version;
  final DateTime fetchedAt;
  const OrderDetailRow({
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
    {
      map['fetched_at'] = Variable<int>(
        $OrderDetailsTable.$converterfetchedAt.toSql(fetchedAt),
      );
    }
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

  factory OrderDetailRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderDetailRow(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
      etag: serializer.fromJson<String?>(json['etag']),
      version: serializer.fromJson<int>(json['version']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
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
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  OrderDetailRow copyWith({
    String? id,
    String? json,
    Value<String?> etag = const Value.absent(),
    int? version,
    DateTime? fetchedAt,
  }) => OrderDetailRow(
    id: id ?? this.id,
    json: json ?? this.json,
    etag: etag.present ? etag.value : this.etag,
    version: version ?? this.version,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  OrderDetailRow copyWithCompanion(OrderDetailsCompanion data) {
    return OrderDetailRow(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
      etag: data.etag.present ? data.etag.value : this.etag,
      version: data.version.present ? data.version.value : this.version,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderDetailRow(')
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
      (other is OrderDetailRow &&
          other.id == this.id &&
          other.json == this.json &&
          other.etag == this.etag &&
          other.version == this.version &&
          other.fetchedAt == this.fetchedAt);
}

class OrderDetailsCompanion extends UpdateCompanion<OrderDetailRow> {
  final Value<String> id;
  final Value<String> json;
  final Value<String?> etag;
  final Value<int> version;
  final Value<DateTime> fetchedAt;
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
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json),
       version = Value(version),
       fetchedAt = Value(fetchedAt);
  static Insertable<OrderDetailRow> custom({
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
    Value<DateTime>? fetchedAt,
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
      map['fetched_at'] = Variable<int>(
        $OrderDetailsTable.$converterfetchedAt.toSql(fetchedAt.value),
      );
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $OrderDetailsTable orderDetails = $OrderDetailsTable(this);
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
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final SyncStateDao syncStateDao = SyncStateDao(this as AppDatabase);
  late final OutboxDao outboxDao = OutboxDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    orders,
    outbox,
    syncState,
    orderDetails,
    ordersCreatedIdx,
    ordersStatusIdx,
    outboxOrderIdx,
  ];
}

typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  required String id,
  required String status,
  required int version,
  required int totalMinor,
  Value<String> currency,
  Value<int> lineCount,
  Value<int> itemCount,
  Value<String?> primarySku,
  Value<String?> primaryName,
  Value<String?> primaryImageUrl,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<String> id,
  Value<String> status,
  Value<int> version,
  Value<int> totalMinor,
  Value<String> currency,
  Value<int> lineCount,
  Value<int> itemCount,
  Value<String?> primarySku,
  Value<String?> primaryName,
  Value<String?> primaryImageUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineCount => $composableBuilder(
    column: $table.lineCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primarySku => $composableBuilder(
    column: $table.primarySku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryName => $composableBuilder(
    column: $table.primaryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineCount => $composableBuilder(
    column: $table.lineCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primarySku => $composableBuilder(
    column: $table.primarySku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryName => $composableBuilder(
    column: $table.primaryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get lineCount =>
      $composableBuilder(column: $table.lineCount, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<String> get primarySku => $composableBuilder(
    column: $table.primarySku,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryName => $composableBuilder(
    column: $table.primaryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          OrderRow,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (OrderRow, BaseReferences<_$AppDatabase, $OrdersTable, OrderRow>),
          OrderRow,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> lineCount = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<String?> primarySku = const Value.absent(),
                Value<String?> primaryName = const Value.absent(),
                Value<String?> primaryImageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                status: status,
                version: version,
                totalMinor: totalMinor,
                currency: currency,
                lineCount: lineCount,
                itemCount: itemCount,
                primarySku: primarySku,
                primaryName: primaryName,
                primaryImageUrl: primaryImageUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                required int version,
                required int totalMinor,
                Value<String> currency = const Value.absent(),
                Value<int> lineCount = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<String?> primarySku = const Value.absent(),
                Value<String?> primaryName = const Value.absent(),
                Value<String?> primaryImageUrl = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                status: status,
                version: version,
                totalMinor: totalMinor,
                currency: currency,
                lineCount: lineCount,
                itemCount: itemCount,
                primarySku: primarySku,
                primaryName: primaryName,
                primaryImageUrl: primaryImageUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdersTable, OrderRow>(table),
                  BaseReferences<_$AppDatabase, $OrdersTable, OrderRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      OrderRow,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (OrderRow, BaseReferences<_$AppDatabase, $OrdersTable, OrderRow>),
      OrderRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  required String orderId,
  required String kind,
  required String payload,
  required String idempotencyKey,
  Value<int?> ifMatchVersion,
  Value<String> state,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<String?> serverSnapshot,
  required DateTime createdAt,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  Value<String> orderId,
  Value<String> kind,
  Value<String> payload,
  Value<String> idempotencyKey,
  Value<int?> ifMatchVersion,
  Value<String> state,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<String?> serverSnapshot,
  Value<DateTime> createdAt,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ifMatchVersion => $composableBuilder(
    column: $table.ifMatchVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get nextAttemptAt =>
      $composableBuilder(
        column: $table.nextAttemptAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverSnapshot => $composableBuilder(
    column: $table.serverSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ifMatchVersion => $composableBuilder(
    column: $table.ifMatchVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverSnapshot => $composableBuilder(
    column: $table.serverSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ifMatchVersion => $composableBuilder(
    column: $table.ifMatchVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get nextAttemptAt =>
      $composableBuilder(
        column: $table.nextAttemptAt,
        builder: (column) => column,
      );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get serverSnapshot => $composableBuilder(
    column: $table.serverSnapshot,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<int?> ifMatchVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverSnapshot = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                orderId: orderId,
                kind: kind,
                payload: payload,
                idempotencyKey: idempotencyKey,
                ifMatchVersion: ifMatchVersion,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                serverSnapshot: serverSnapshot,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderId,
                required String kind,
                required String payload,
                required String idempotencyKey,
                Value<int?> ifMatchVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverSnapshot = const Value.absent(),
                required DateTime createdAt,
              }) => OutboxCompanion.insert(
                id: id,
                orderId: orderId,
                kind: kind,
                payload: payload,
                idempotencyKey: idempotencyKey,
                ifMatchVersion: ifMatchVersion,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                serverSnapshot: serverSnapshot,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  Value<String?> userId,
  Value<int?> syncSeq,
  Value<String?> olderCursor,
  Value<bool> reachedEnd,
  Value<DateTime?> lastSyncedAt,
  Value<DateTime?> oldestCreatedAt,
  Value<String?> oldestId,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  Value<String?> userId,
  Value<int?> syncSeq,
  Value<String?> olderCursor,
  Value<bool> reachedEnd,
  Value<DateTime?> lastSyncedAt,
  Value<DateTime?> oldestCreatedAt,
  Value<String?> oldestId,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncSeq => $composableBuilder(
    column: $table.syncSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get olderCursor => $composableBuilder(
    column: $table.olderCursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reachedEnd => $composableBuilder(
    column: $table.reachedEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get lastSyncedAt =>
      $composableBuilder(
        column: $table.lastSyncedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
  get oldestCreatedAt => $composableBuilder(
    column: $table.oldestCreatedAt,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get oldestId => $composableBuilder(
    column: $table.oldestId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncSeq => $composableBuilder(
    column: $table.syncSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get olderCursor => $composableBuilder(
    column: $table.olderCursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reachedEnd => $composableBuilder(
    column: $table.reachedEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get oldestCreatedAt => $composableBuilder(
    column: $table.oldestCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldestId => $composableBuilder(
    column: $table.oldestId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get syncSeq =>
      $composableBuilder(column: $table.syncSeq, builder: (column) => column);

  GeneratedColumn<String> get olderCursor => $composableBuilder(
    column: $table.olderCursor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reachedEnd => $composableBuilder(
    column: $table.reachedEnd,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, int> get lastSyncedAt =>
      $composableBuilder(
        column: $table.lastSyncedAt,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, int> get oldestCreatedAt =>
      $composableBuilder(
        column: $table.oldestCreatedAt,
        builder: (column) => column,
      );

  GeneratedColumn<String> get oldestId =>
      $composableBuilder(column: $table.oldestId, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateRow,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int?> syncSeq = const Value.absent(),
                Value<String?> olderCursor = const Value.absent(),
                Value<bool> reachedEnd = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> oldestCreatedAt = const Value.absent(),
                Value<String?> oldestId = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                userId: userId,
                syncSeq: syncSeq,
                olderCursor: olderCursor,
                reachedEnd: reachedEnd,
                lastSyncedAt: lastSyncedAt,
                oldestCreatedAt: oldestCreatedAt,
                oldestId: oldestId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int?> syncSeq = const Value.absent(),
                Value<String?> olderCursor = const Value.absent(),
                Value<bool> reachedEnd = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> oldestCreatedAt = const Value.absent(),
                Value<String?> oldestId = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                userId: userId,
                syncSeq: syncSeq,
                olderCursor: olderCursor,
                reachedEnd: reachedEnd,
                lastSyncedAt: lastSyncedAt,
                oldestCreatedAt: oldestCreatedAt,
                oldestId: oldestId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateRow>(table),
                  BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateRow,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;
typedef $$OrderDetailsTableCreateCompanionBuilder =
    OrderDetailsCompanion Function({
      required String id,
      required String json,
      Value<String?> etag,
      required int version,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$OrderDetailsTableUpdateCompanionBuilder =
    OrderDetailsCompanion Function({
      Value<String> id,
      Value<String> json,
      Value<String?> etag,
      Value<int> version,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$OrderDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderDetailsTable> {
  $$OrderDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get fetchedAt =>
      $composableBuilder(
        column: $table.fetchedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$OrderDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderDetailsTable> {
  $$OrderDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrderDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderDetailsTable> {
  $$OrderDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$OrderDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderDetailsTable,
          OrderDetailRow,
          $$OrderDetailsTableFilterComposer,
          $$OrderDetailsTableOrderingComposer,
          $$OrderDetailsTableAnnotationComposer,
          $$OrderDetailsTableCreateCompanionBuilder,
          $$OrderDetailsTableUpdateCompanionBuilder,
          (
            OrderDetailRow,
            BaseReferences<_$AppDatabase, $OrderDetailsTable, OrderDetailRow>,
          ),
          OrderDetailRow,
          PrefetchHooks Function()
        > {
  $$OrderDetailsTableTableManager(_$AppDatabase db, $OrderDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderDetailsCompanion(
                id: id,
                json: json,
                etag: etag,
                version: version,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String json,
                Value<String?> etag = const Value.absent(),
                required int version,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => OrderDetailsCompanion.insert(
                id: id,
                json: json,
                etag: etag,
                version: version,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderDetailsTable, OrderDetailRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OrderDetailsTable,
                    OrderDetailRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrderDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderDetailsTable,
      OrderDetailRow,
      $$OrderDetailsTableFilterComposer,
      $$OrderDetailsTableOrderingComposer,
      $$OrderDetailsTableAnnotationComposer,
      $$OrderDetailsTableCreateCompanionBuilder,
      $$OrderDetailsTableUpdateCompanionBuilder,
      (
        OrderDetailRow,
        BaseReferences<_$AppDatabase, $OrderDetailsTable, OrderDetailRow>,
      ),
      OrderDetailRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$OrderDetailsTableTableManager get orderDetails =>
      $$OrderDetailsTableTableManager(_db, _db.orderDetails);
}
