part of 'order_models.dart';

T _$identity<T>(T value) => value;

mixin _$PrimaryItem {
  String get sku;
  String get name;
  String? get imageUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PrimaryItemCopyWith<PrimaryItem> get copyWith =>
      _$PrimaryItemCopyWithImpl<PrimaryItem>(this as PrimaryItem, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as PrimaryItem;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PrimaryItem &&
            (identical(other.sku, _this.sku) || other.sku == _this.sku) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.imageUrl, _this.imageUrl) ||
                other.imageUrl == _this.imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as PrimaryItem;
    return Object.hash(runtimeType, _this.sku, _this.name, _this.imageUrl);
  }

  @override
  String toString() {
    final _this = this as PrimaryItem;
    return 'PrimaryItem(sku: ${_this.sku}, name: ${_this.name}, imageUrl: ${_this.imageUrl})';
  }
}

abstract mixin class $PrimaryItemCopyWith<$Res> {
  factory $PrimaryItemCopyWith(
    PrimaryItem value,
    $Res Function(PrimaryItem) _then,
  ) = _$PrimaryItemCopyWithImpl;
  @useResult
  $Res call({String sku, String name, String? imageUrl});
}

class _$PrimaryItemCopyWithImpl<$Res> implements $PrimaryItemCopyWith<$Res> {
  _$PrimaryItemCopyWithImpl(this._self, this._then);

  final PrimaryItem _self;
  final $Res Function(PrimaryItem) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? name = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      PrimaryItem(
        sku: null == sku ? _self.sku : sku as String,
        name: null == name ? _self.name : name as String,
        imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      ),
    );
  }
}

extension PrimaryItemPatterns on PrimaryItem {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PrimaryItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PrimaryItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PrimaryItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String sku, String name, String? imageUrl)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem() when $default != null:
        return $default(_that.sku, _that.name, _that.imageUrl);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String sku, String name, String? imageUrl) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem():
        return $default(_that.sku, _that.name, _that.imageUrl);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String sku, String name, String? imageUrl)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrimaryItem() when $default != null:
        return $default(_that.sku, _that.name, _that.imageUrl);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _PrimaryItem implements PrimaryItem {
  const _PrimaryItem({required this.sku, required this.name, this.imageUrl});
  factory _PrimaryItem.fromJson(Map<String, dynamic> json) =>
      _$PrimaryItemFromJson(json);

  @override
  final String sku;
  @override
  final String name;
  @override
  final String? imageUrl;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PrimaryItemCopyWith<_PrimaryItem> get copyWith =>
      __$PrimaryItemCopyWithImpl<_PrimaryItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PrimaryItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PrimaryItem &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, sku, name, imageUrl);
  }

  @override
  String toString() {
    return 'PrimaryItem(sku: $sku, name: $name, imageUrl: $imageUrl)';
  }
}

abstract mixin class _$PrimaryItemCopyWith<$Res>
    implements $PrimaryItemCopyWith<$Res> {
  factory _$PrimaryItemCopyWith(
    _PrimaryItem value,
    $Res Function(_PrimaryItem) _then,
  ) = __$PrimaryItemCopyWithImpl;
  @override
  @useResult
  $Res call({String sku, String name, String? imageUrl});
}

class __$PrimaryItemCopyWithImpl<$Res> implements _$PrimaryItemCopyWith<$Res> {
  __$PrimaryItemCopyWithImpl(this._self, this._then);

  final _PrimaryItem _self;
  final $Res Function(_PrimaryItem) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sku = null,
    Object? name = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _PrimaryItem(
        sku: null == sku ? _self.sku : sku as String,
        name: null == name ? _self.name : name as String,
        imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      ),
    );
  }
}

mixin _$OrderSummary {
  String get id;
  String get status;
  int get version;
  int get totalMinor;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get currency;
  int get lineCount;
  int get itemCount;
  PrimaryItem? get primaryItem;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderSummaryCopyWith<OrderSummary> get copyWith =>
      _$OrderSummaryCopyWithImpl<OrderSummary>(
        this as OrderSummary,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderSummary;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderSummary &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.version, _this.version) ||
                other.version == _this.version) &&
            (identical(other.totalMinor, _this.totalMinor) ||
                other.totalMinor == _this.totalMinor) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt) &&
            (identical(other.updatedAt, _this.updatedAt) ||
                other.updatedAt == _this.updatedAt) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.lineCount, _this.lineCount) ||
                other.lineCount == _this.lineCount) &&
            (identical(other.itemCount, _this.itemCount) ||
                other.itemCount == _this.itemCount) &&
            (identical(other.primaryItem, _this.primaryItem) ||
                other.primaryItem == _this.primaryItem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderSummary;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.status,
      _this.version,
      _this.totalMinor,
      _this.createdAt,
      _this.updatedAt,
      _this.currency,
      _this.lineCount,
      _this.itemCount,
      _this.primaryItem,
    );
  }

  @override
  String toString() {
    final _this = this as OrderSummary;
    return 'OrderSummary(id: ${_this.id}, status: ${_this.status}, version: ${_this.version}, totalMinor: ${_this.totalMinor}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, currency: ${_this.currency}, lineCount: ${_this.lineCount}, itemCount: ${_this.itemCount}, primaryItem: ${_this.primaryItem})';
  }
}

abstract mixin class $OrderSummaryCopyWith<$Res> {
  factory $OrderSummaryCopyWith(
    OrderSummary value,
    $Res Function(OrderSummary) _then,
  ) = _$OrderSummaryCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String status,
    int version,
    int totalMinor,
    DateTime createdAt,
    DateTime updatedAt,
    String currency,
    int lineCount,
    int itemCount,
    PrimaryItem? primaryItem,
  });

  $PrimaryItemCopyWith<$Res>? get primaryItem;
}

class _$OrderSummaryCopyWithImpl<$Res> implements $OrderSummaryCopyWith<$Res> {
  _$OrderSummaryCopyWithImpl(this._self, this._then);

  final OrderSummary _self;
  final $Res Function(OrderSummary) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? version = null,
    Object? totalMinor = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currency = null,
    Object? lineCount = null,
    Object? itemCount = null,
    Object? primaryItem = freezed,
  }) {
    return _then(
      OrderSummary(
        id: null == id ? _self.id : id as String,
        status: null == status ? _self.status : status as String,
        version: null == version ? _self.version : version as int,
        totalMinor: null == totalMinor ? _self.totalMinor : totalMinor as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        updatedAt: null == updatedAt ? _self.updatedAt : updatedAt as DateTime,
        currency: null == currency ? _self.currency : currency as String,
        lineCount: null == lineCount ? _self.lineCount : lineCount as int,
        itemCount: null == itemCount ? _self.itemCount : itemCount as int,
        primaryItem: freezed == primaryItem
            ? _self.primaryItem
            : primaryItem as PrimaryItem?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $PrimaryItemCopyWith<$Res>? get primaryItem {
    if (_self.primaryItem == null) {
      return null;
    }

    return $PrimaryItemCopyWith<$Res>(_self.primaryItem!, (value) {
      return _then(_self.copyWith(primaryItem: value));
    });
  }
}

extension OrderSummaryPatterns on OrderSummary {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderSummary() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderSummary():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderSummary() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderSummary() when $default != null:
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderSummary():
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderSummary() when $default != null:
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderSummary implements OrderSummary {
  const _OrderSummary({
    required this.id,
    required this.status,
    required this.version,
    required this.totalMinor,
    required this.createdAt,
    required this.updatedAt,
    this.currency = 'THB',
    this.lineCount = 0,
    this.itemCount = 0,
    this.primaryItem,
  });
  factory _OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final int version;
  @override
  final int totalMinor;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final int lineCount;
  @override
  @JsonKey()
  final int itemCount;
  @override
  final PrimaryItem? primaryItem;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderSummaryCopyWith<_OrderSummary> get copyWith =>
      __$OrderSummaryCopyWithImpl<_OrderSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderSummaryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.totalMinor, totalMinor) ||
                other.totalMinor == totalMinor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.lineCount, lineCount) ||
                other.lineCount == lineCount) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.primaryItem, primaryItem) ||
                other.primaryItem == primaryItem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      status,
      version,
      totalMinor,
      createdAt,
      updatedAt,
      currency,
      lineCount,
      itemCount,
      primaryItem,
    );
  }

  @override
  String toString() {
    return 'OrderSummary(id: $id, status: $status, version: $version, totalMinor: $totalMinor, createdAt: $createdAt, updatedAt: $updatedAt, currency: $currency, lineCount: $lineCount, itemCount: $itemCount, primaryItem: $primaryItem)';
  }
}

abstract mixin class _$OrderSummaryCopyWith<$Res>
    implements $OrderSummaryCopyWith<$Res> {
  factory _$OrderSummaryCopyWith(
    _OrderSummary value,
    $Res Function(_OrderSummary) _then,
  ) = __$OrderSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String status,
    int version,
    int totalMinor,
    DateTime createdAt,
    DateTime updatedAt,
    String currency,
    int lineCount,
    int itemCount,
    PrimaryItem? primaryItem,
  });

  @override
  $PrimaryItemCopyWith<$Res>? get primaryItem;
}

class __$OrderSummaryCopyWithImpl<$Res>
    implements _$OrderSummaryCopyWith<$Res> {
  __$OrderSummaryCopyWithImpl(this._self, this._then);

  final _OrderSummary _self;
  final $Res Function(_OrderSummary) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? version = null,
    Object? totalMinor = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currency = null,
    Object? lineCount = null,
    Object? itemCount = null,
    Object? primaryItem = freezed,
  }) {
    return _then(
      _OrderSummary(
        id: null == id ? _self.id : id as String,
        status: null == status ? _self.status : status as String,
        version: null == version ? _self.version : version as int,
        totalMinor: null == totalMinor ? _self.totalMinor : totalMinor as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        updatedAt: null == updatedAt ? _self.updatedAt : updatedAt as DateTime,
        currency: null == currency ? _self.currency : currency as String,
        lineCount: null == lineCount ? _self.lineCount : lineCount as int,
        itemCount: null == itemCount ? _self.itemCount : itemCount as int,
        primaryItem: freezed == primaryItem
            ? _self.primaryItem
            : primaryItem as PrimaryItem?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $PrimaryItemCopyWith<$Res>? get primaryItem {
    if (_self.primaryItem == null) {
      return null;
    }

    return $PrimaryItemCopyWith<$Res>(_self.primaryItem!, (value) {
      return _then(_self.copyWith(primaryItem: value));
    });
  }
}

mixin _$OrderLine {
  String get sku;
  String get name;
  int get quantity;
  int get unitPriceMinor;
  String? get imageUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderLineCopyWith<OrderLine> get copyWith =>
      _$OrderLineCopyWithImpl<OrderLine>(this as OrderLine, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderLine;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderLine &&
            (identical(other.sku, _this.sku) || other.sku == _this.sku) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.quantity, _this.quantity) ||
                other.quantity == _this.quantity) &&
            (identical(other.unitPriceMinor, _this.unitPriceMinor) ||
                other.unitPriceMinor == _this.unitPriceMinor) &&
            (identical(other.imageUrl, _this.imageUrl) ||
                other.imageUrl == _this.imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderLine;
    return Object.hash(
      runtimeType,
      _this.sku,
      _this.name,
      _this.quantity,
      _this.unitPriceMinor,
      _this.imageUrl,
    );
  }

  @override
  String toString() {
    final _this = this as OrderLine;
    return 'OrderLine(sku: ${_this.sku}, name: ${_this.name}, quantity: ${_this.quantity}, unitPriceMinor: ${_this.unitPriceMinor}, imageUrl: ${_this.imageUrl})';
  }
}

abstract mixin class $OrderLineCopyWith<$Res> {
  factory $OrderLineCopyWith(OrderLine value, $Res Function(OrderLine) _then) =
      _$OrderLineCopyWithImpl;
  @useResult
  $Res call({
    String sku,
    String name,
    int quantity,
    int unitPriceMinor,
    String? imageUrl,
  });
}

class _$OrderLineCopyWithImpl<$Res> implements $OrderLineCopyWith<$Res> {
  _$OrderLineCopyWithImpl(this._self, this._then);

  final OrderLine _self;
  final $Res Function(OrderLine) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? name = null,
    Object? quantity = null,
    Object? unitPriceMinor = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      OrderLine(
        sku: null == sku ? _self.sku : sku as String,
        name: null == name ? _self.name : name as String,
        quantity: null == quantity ? _self.quantity : quantity as int,
        unitPriceMinor: null == unitPriceMinor
            ? _self.unitPriceMinor
            : unitPriceMinor as int,
        imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      ),
    );
  }
}

extension OrderLinePatterns on OrderLine {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderLine value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderLine() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderLine value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderLine():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderLine value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderLine() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String sku,
      String name,
      int quantity,
      int unitPriceMinor,
      String? imageUrl,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderLine() when $default != null:
        return $default(
          _that.sku,
          _that.name,
          _that.quantity,
          _that.unitPriceMinor,
          _that.imageUrl,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String sku,
      String name,
      int quantity,
      int unitPriceMinor,
      String? imageUrl,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderLine():
        return $default(
          _that.sku,
          _that.name,
          _that.quantity,
          _that.unitPriceMinor,
          _that.imageUrl,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String sku,
      String name,
      int quantity,
      int unitPriceMinor,
      String? imageUrl,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderLine() when $default != null:
        return $default(
          _that.sku,
          _that.name,
          _that.quantity,
          _that.unitPriceMinor,
          _that.imageUrl,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderLine implements OrderLine {
  const _OrderLine({
    required this.sku,
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    this.imageUrl,
  });
  factory _OrderLine.fromJson(Map<String, dynamic> json) =>
      _$OrderLineFromJson(json);

  @override
  final String sku;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final int unitPriceMinor;
  @override
  final String? imageUrl;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderLineCopyWith<_OrderLine> get copyWith =>
      __$OrderLineCopyWithImpl<_OrderLine>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderLineToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderLine &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPriceMinor, unitPriceMinor) ||
                other.unitPriceMinor == unitPriceMinor) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      sku,
      name,
      quantity,
      unitPriceMinor,
      imageUrl,
    );
  }

  @override
  String toString() {
    return 'OrderLine(sku: $sku, name: $name, quantity: $quantity, unitPriceMinor: $unitPriceMinor, imageUrl: $imageUrl)';
  }
}

abstract mixin class _$OrderLineCopyWith<$Res>
    implements $OrderLineCopyWith<$Res> {
  factory _$OrderLineCopyWith(
    _OrderLine value,
    $Res Function(_OrderLine) _then,
  ) = __$OrderLineCopyWithImpl;
  @override
  @useResult
  $Res call({
    String sku,
    String name,
    int quantity,
    int unitPriceMinor,
    String? imageUrl,
  });
}

class __$OrderLineCopyWithImpl<$Res> implements _$OrderLineCopyWith<$Res> {
  __$OrderLineCopyWithImpl(this._self, this._then);

  final _OrderLine _self;
  final $Res Function(_OrderLine) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sku = null,
    Object? name = null,
    Object? quantity = null,
    Object? unitPriceMinor = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _OrderLine(
        sku: null == sku ? _self.sku : sku as String,
        name: null == name ? _self.name : name as String,
        quantity: null == quantity ? _self.quantity : quantity as int,
        unitPriceMinor: null == unitPriceMinor
            ? _self.unitPriceMinor
            : unitPriceMinor as int,
        imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      ),
    );
  }
}

mixin _$OrderHistoryEntry {
  String get status;
  DateTime get at;
  String? get by;
  String? get note;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderHistoryEntryCopyWith<OrderHistoryEntry> get copyWith =>
      _$OrderHistoryEntryCopyWithImpl<OrderHistoryEntry>(
        this as OrderHistoryEntry,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderHistoryEntry;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderHistoryEntry &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.at, _this.at) || other.at == _this.at) &&
            (identical(other.by, _this.by) || other.by == _this.by) &&
            (identical(other.note, _this.note) || other.note == _this.note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderHistoryEntry;
    return Object.hash(
      runtimeType,
      _this.status,
      _this.at,
      _this.by,
      _this.note,
    );
  }

  @override
  String toString() {
    final _this = this as OrderHistoryEntry;
    return 'OrderHistoryEntry(status: ${_this.status}, at: ${_this.at}, by: ${_this.by}, note: ${_this.note})';
  }
}

abstract mixin class $OrderHistoryEntryCopyWith<$Res> {
  factory $OrderHistoryEntryCopyWith(
    OrderHistoryEntry value,
    $Res Function(OrderHistoryEntry) _then,
  ) = _$OrderHistoryEntryCopyWithImpl;
  @useResult
  $Res call({String status, DateTime at, String? by, String? note});
}

class _$OrderHistoryEntryCopyWithImpl<$Res>
    implements $OrderHistoryEntryCopyWith<$Res> {
  _$OrderHistoryEntryCopyWithImpl(this._self, this._then);

  final OrderHistoryEntry _self;
  final $Res Function(OrderHistoryEntry) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? at = null,
    Object? by = freezed,
    Object? note = freezed,
  }) {
    return _then(
      OrderHistoryEntry(
        status: null == status ? _self.status : status as String,
        at: null == at ? _self.at : at as DateTime,
        by: freezed == by ? _self.by : by as String?,
        note: freezed == note ? _self.note : note as String?,
      ),
    );
  }
}

extension OrderHistoryEntryPatterns on OrderHistoryEntry {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderHistoryEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderHistoryEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderHistoryEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String status, DateTime at, String? by, String? note)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry() when $default != null:
        return $default(_that.status, _that.at, _that.by, _that.note);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String status, DateTime at, String? by, String? note)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry():
        return $default(_that.status, _that.at, _that.by, _that.note);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String status, DateTime at, String? by, String? note)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderHistoryEntry() when $default != null:
        return $default(_that.status, _that.at, _that.by, _that.note);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderHistoryEntry implements OrderHistoryEntry {
  const _OrderHistoryEntry({
    required this.status,
    required this.at,
    this.by,
    this.note,
  });
  factory _OrderHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryEntryFromJson(json);

  @override
  final String status;
  @override
  final DateTime at;
  @override
  final String? by;
  @override
  final String? note;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderHistoryEntryCopyWith<_OrderHistoryEntry> get copyWith =>
      __$OrderHistoryEntryCopyWithImpl<_OrderHistoryEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderHistoryEntryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderHistoryEntry &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.by, by) || other.by == by) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, status, at, by, note);
  }

  @override
  String toString() {
    return 'OrderHistoryEntry(status: $status, at: $at, by: $by, note: $note)';
  }
}

abstract mixin class _$OrderHistoryEntryCopyWith<$Res>
    implements $OrderHistoryEntryCopyWith<$Res> {
  factory _$OrderHistoryEntryCopyWith(
    _OrderHistoryEntry value,
    $Res Function(_OrderHistoryEntry) _then,
  ) = __$OrderHistoryEntryCopyWithImpl;
  @override
  @useResult
  $Res call({String status, DateTime at, String? by, String? note});
}

class __$OrderHistoryEntryCopyWithImpl<$Res>
    implements _$OrderHistoryEntryCopyWith<$Res> {
  __$OrderHistoryEntryCopyWithImpl(this._self, this._then);

  final _OrderHistoryEntry _self;
  final $Res Function(_OrderHistoryEntry) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? at = null,
    Object? by = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _OrderHistoryEntry(
        status: null == status ? _self.status : status as String,
        at: null == at ? _self.at : at as DateTime,
        by: freezed == by ? _self.by : by as String?,
        note: freezed == note ? _self.note : note as String?,
      ),
    );
  }
}

mixin _$OrderNote {
  String get id;
  String get text;
  String get author;
  DateTime get createdAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderNoteCopyWith<OrderNote> get copyWith =>
      _$OrderNoteCopyWithImpl<OrderNote>(this as OrderNote, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderNote;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderNote &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.text, _this.text) || other.text == _this.text) &&
            (identical(other.author, _this.author) ||
                other.author == _this.author) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderNote;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.text,
      _this.author,
      _this.createdAt,
    );
  }

  @override
  String toString() {
    final _this = this as OrderNote;
    return 'OrderNote(id: ${_this.id}, text: ${_this.text}, author: ${_this.author}, createdAt: ${_this.createdAt})';
  }
}

abstract mixin class $OrderNoteCopyWith<$Res> {
  factory $OrderNoteCopyWith(OrderNote value, $Res Function(OrderNote) _then) =
      _$OrderNoteCopyWithImpl;
  @useResult
  $Res call({String id, String text, String author, DateTime createdAt});
}

class _$OrderNoteCopyWithImpl<$Res> implements $OrderNoteCopyWith<$Res> {
  _$OrderNoteCopyWithImpl(this._self, this._then);

  final OrderNote _self;
  final $Res Function(OrderNote) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? author = null,
    Object? createdAt = null,
  }) {
    return _then(
      OrderNote(
        id: null == id ? _self.id : id as String,
        text: null == text ? _self.text : text as String,
        author: null == author ? _self.author : author as String,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
      ),
    );
  }
}

extension OrderNotePatterns on OrderNote {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderNote value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderNote() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderNote value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderNote():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderNote value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderNote() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String text, String author, DateTime createdAt)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderNote() when $default != null:
        return $default(_that.id, _that.text, _that.author, _that.createdAt);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String text, String author, DateTime createdAt)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderNote():
        return $default(_that.id, _that.text, _that.author, _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String text,
      String author,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderNote() when $default != null:
        return $default(_that.id, _that.text, _that.author, _that.createdAt);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderNote implements OrderNote {
  const _OrderNote({
    required this.id,
    required this.text,
    required this.author,
    required this.createdAt,
  });
  factory _OrderNote.fromJson(Map<String, dynamic> json) =>
      _$OrderNoteFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final String author;
  @override
  final DateTime createdAt;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderNoteCopyWith<_OrderNote> get copyWith =>
      __$OrderNoteCopyWithImpl<_OrderNote>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderNoteToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderNote &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, text, author, createdAt);
  }

  @override
  String toString() {
    return 'OrderNote(id: $id, text: $text, author: $author, createdAt: $createdAt)';
  }
}

abstract mixin class _$OrderNoteCopyWith<$Res>
    implements $OrderNoteCopyWith<$Res> {
  factory _$OrderNoteCopyWith(
    _OrderNote value,
    $Res Function(_OrderNote) _then,
  ) = __$OrderNoteCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String text, String author, DateTime createdAt});
}

class __$OrderNoteCopyWithImpl<$Res> implements _$OrderNoteCopyWith<$Res> {
  __$OrderNoteCopyWithImpl(this._self, this._then);

  final _OrderNote _self;
  final $Res Function(_OrderNote) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? author = null,
    Object? createdAt = null,
  }) {
    return _then(
      _OrderNote(
        id: null == id ? _self.id : id as String,
        text: null == text ? _self.text : text as String,
        author: null == author ? _self.author : author as String,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
      ),
    );
  }
}

mixin _$OrderAttachment {
  String get id;
  String get contentType;
  int get size;
  DateTime get createdAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderAttachmentCopyWith<OrderAttachment> get copyWith =>
      _$OrderAttachmentCopyWithImpl<OrderAttachment>(
        this as OrderAttachment,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderAttachment;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderAttachment &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.contentType, _this.contentType) ||
                other.contentType == _this.contentType) &&
            (identical(other.size, _this.size) || other.size == _this.size) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderAttachment;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.contentType,
      _this.size,
      _this.createdAt,
    );
  }

  @override
  String toString() {
    final _this = this as OrderAttachment;
    return 'OrderAttachment(id: ${_this.id}, contentType: ${_this.contentType}, size: ${_this.size}, createdAt: ${_this.createdAt})';
  }
}

abstract mixin class $OrderAttachmentCopyWith<$Res> {
  factory $OrderAttachmentCopyWith(
    OrderAttachment value,
    $Res Function(OrderAttachment) _then,
  ) = _$OrderAttachmentCopyWithImpl;
  @useResult
  $Res call({String id, String contentType, int size, DateTime createdAt});
}

class _$OrderAttachmentCopyWithImpl<$Res>
    implements $OrderAttachmentCopyWith<$Res> {
  _$OrderAttachmentCopyWithImpl(this._self, this._then);

  final OrderAttachment _self;
  final $Res Function(OrderAttachment) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentType = null,
    Object? size = null,
    Object? createdAt = null,
  }) {
    return _then(
      OrderAttachment(
        id: null == id ? _self.id : id as String,
        contentType: null == contentType
            ? _self.contentType
            : contentType as String,
        size: null == size ? _self.size : size as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
      ),
    );
  }
}

extension OrderAttachmentPatterns on OrderAttachment {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderAttachment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderAttachment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderAttachment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String contentType,
      int size,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment() when $default != null:
        return $default(
          _that.id,
          _that.contentType,
          _that.size,
          _that.createdAt,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String contentType,
      int size,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment():
        return $default(
          _that.id,
          _that.contentType,
          _that.size,
          _that.createdAt,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String contentType,
      int size,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderAttachment() when $default != null:
        return $default(
          _that.id,
          _that.contentType,
          _that.size,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderAttachment implements OrderAttachment {
  const _OrderAttachment({
    required this.id,
    required this.contentType,
    required this.size,
    required this.createdAt,
  });
  factory _OrderAttachment.fromJson(Map<String, dynamic> json) =>
      _$OrderAttachmentFromJson(json);

  @override
  final String id;
  @override
  final String contentType;
  @override
  final int size;
  @override
  final DateTime createdAt;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderAttachmentCopyWith<_OrderAttachment> get copyWith =>
      __$OrderAttachmentCopyWithImpl<_OrderAttachment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderAttachmentToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderAttachment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, contentType, size, createdAt);
  }

  @override
  String toString() {
    return 'OrderAttachment(id: $id, contentType: $contentType, size: $size, createdAt: $createdAt)';
  }
}

abstract mixin class _$OrderAttachmentCopyWith<$Res>
    implements $OrderAttachmentCopyWith<$Res> {
  factory _$OrderAttachmentCopyWith(
    _OrderAttachment value,
    $Res Function(_OrderAttachment) _then,
  ) = __$OrderAttachmentCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String contentType, int size, DateTime createdAt});
}

class __$OrderAttachmentCopyWithImpl<$Res>
    implements _$OrderAttachmentCopyWith<$Res> {
  __$OrderAttachmentCopyWithImpl(this._self, this._then);

  final _OrderAttachment _self;
  final $Res Function(_OrderAttachment) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? contentType = null,
    Object? size = null,
    Object? createdAt = null,
  }) {
    return _then(
      _OrderAttachment(
        id: null == id ? _self.id : id as String,
        contentType: null == contentType
            ? _self.contentType
            : contentType as String,
        size: null == size ? _self.size : size as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
      ),
    );
  }
}

mixin _$OrderDetail {
  String get id;
  String get status;
  int get version;
  int get totalMinor;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get currency;
  int get lineCount;
  int get itemCount;
  PrimaryItem? get primaryItem;
  String? get playerId;
  String? get channel;
  List<OrderLine> get items;
  List<OrderHistoryEntry> get history;
  List<OrderNote> get notes;
  List<OrderAttachment> get attachments;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailCopyWith<OrderDetail> get copyWith =>
      _$OrderDetailCopyWithImpl<OrderDetail>(this as OrderDetail, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderDetail;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetail &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.status, _this.status) ||
                other.status == _this.status) &&
            (identical(other.version, _this.version) ||
                other.version == _this.version) &&
            (identical(other.totalMinor, _this.totalMinor) ||
                other.totalMinor == _this.totalMinor) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt) &&
            (identical(other.updatedAt, _this.updatedAt) ||
                other.updatedAt == _this.updatedAt) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.lineCount, _this.lineCount) ||
                other.lineCount == _this.lineCount) &&
            (identical(other.itemCount, _this.itemCount) ||
                other.itemCount == _this.itemCount) &&
            (identical(other.primaryItem, _this.primaryItem) ||
                other.primaryItem == _this.primaryItem) &&
            (identical(other.playerId, _this.playerId) ||
                other.playerId == _this.playerId) &&
            (identical(other.channel, _this.channel) ||
                other.channel == _this.channel) &&
            const DeepCollectionEquality().equals(other.items, _this.items) &&
            const DeepCollectionEquality().equals(
              other.history,
              _this.history,
            ) &&
            const DeepCollectionEquality().equals(other.notes, _this.notes) &&
            const DeepCollectionEquality().equals(
              other.attachments,
              _this.attachments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderDetail;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.status,
      _this.version,
      _this.totalMinor,
      _this.createdAt,
      _this.updatedAt,
      _this.currency,
      _this.lineCount,
      _this.itemCount,
      _this.primaryItem,
      _this.playerId,
      _this.channel,
      const DeepCollectionEquality().hash(_this.items),
      const DeepCollectionEquality().hash(_this.history),
      const DeepCollectionEquality().hash(_this.notes),
      const DeepCollectionEquality().hash(_this.attachments),
    );
  }

  @override
  String toString() {
    final _this = this as OrderDetail;
    return 'OrderDetail(id: ${_this.id}, status: ${_this.status}, version: ${_this.version}, totalMinor: ${_this.totalMinor}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, currency: ${_this.currency}, lineCount: ${_this.lineCount}, itemCount: ${_this.itemCount}, primaryItem: ${_this.primaryItem}, playerId: ${_this.playerId}, channel: ${_this.channel}, items: ${_this.items}, history: ${_this.history}, notes: ${_this.notes}, attachments: ${_this.attachments})';
  }
}

abstract mixin class $OrderDetailCopyWith<$Res> {
  factory $OrderDetailCopyWith(
    OrderDetail value,
    $Res Function(OrderDetail) _then,
  ) = _$OrderDetailCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String status,
    int version,
    int totalMinor,
    DateTime createdAt,
    DateTime updatedAt,
    String currency,
    int lineCount,
    int itemCount,
    PrimaryItem? primaryItem,
    String? playerId,
    String? channel,
    List<OrderLine> items,
    List<OrderHistoryEntry> history,
    List<OrderNote> notes,
    List<OrderAttachment> attachments,
  });

  $PrimaryItemCopyWith<$Res>? get primaryItem;
}

class _$OrderDetailCopyWithImpl<$Res> implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._self, this._then);

  final OrderDetail _self;
  final $Res Function(OrderDetail) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? version = null,
    Object? totalMinor = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currency = null,
    Object? lineCount = null,
    Object? itemCount = null,
    Object? primaryItem = freezed,
    Object? playerId = freezed,
    Object? channel = freezed,
    Object? items = null,
    Object? history = null,
    Object? notes = null,
    Object? attachments = null,
  }) {
    return _then(
      OrderDetail(
        id: null == id ? _self.id : id as String,
        status: null == status ? _self.status : status as String,
        version: null == version ? _self.version : version as int,
        totalMinor: null == totalMinor ? _self.totalMinor : totalMinor as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        updatedAt: null == updatedAt ? _self.updatedAt : updatedAt as DateTime,
        currency: null == currency ? _self.currency : currency as String,
        lineCount: null == lineCount ? _self.lineCount : lineCount as int,
        itemCount: null == itemCount ? _self.itemCount : itemCount as int,
        primaryItem: freezed == primaryItem
            ? _self.primaryItem
            : primaryItem as PrimaryItem?,
        playerId: freezed == playerId ? _self.playerId : playerId as String?,
        channel: freezed == channel ? _self.channel : channel as String?,
        items: null == items ? _self.items : items as List<OrderLine>,
        history: null == history
            ? _self.history
            : history as List<OrderHistoryEntry>,
        notes: null == notes ? _self.notes : notes as List<OrderNote>,
        attachments: null == attachments
            ? _self.attachments
            : attachments as List<OrderAttachment>,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $PrimaryItemCopyWith<$Res>? get primaryItem {
    if (_self.primaryItem == null) {
      return null;
    }

    return $PrimaryItemCopyWith<$Res>(_self.primaryItem!, (value) {
      return _then(_self.copyWith(primaryItem: value));
    });
  }
}

extension OrderDetailPatterns on OrderDetail {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderDetail() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetail():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetail() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
      String? playerId,
      String? channel,
      List<OrderLine> items,
      List<OrderHistoryEntry> history,
      List<OrderNote> notes,
      List<OrderAttachment> attachments,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderDetail() when $default != null:
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
          _that.playerId,
          _that.channel,
          _that.items,
          _that.history,
          _that.notes,
          _that.attachments,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
      String? playerId,
      String? channel,
      List<OrderLine> items,
      List<OrderHistoryEntry> history,
      List<OrderNote> notes,
      List<OrderAttachment> attachments,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetail():
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
          _that.playerId,
          _that.channel,
          _that.items,
          _that.history,
          _that.notes,
          _that.attachments,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String status,
      int version,
      int totalMinor,
      DateTime createdAt,
      DateTime updatedAt,
      String currency,
      int lineCount,
      int itemCount,
      PrimaryItem? primaryItem,
      String? playerId,
      String? channel,
      List<OrderLine> items,
      List<OrderHistoryEntry> history,
      List<OrderNote> notes,
      List<OrderAttachment> attachments,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetail() when $default != null:
        return $default(
          _that.id,
          _that.status,
          _that.version,
          _that.totalMinor,
          _that.createdAt,
          _that.updatedAt,
          _that.currency,
          _that.lineCount,
          _that.itemCount,
          _that.primaryItem,
          _that.playerId,
          _that.channel,
          _that.items,
          _that.history,
          _that.notes,
          _that.attachments,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderDetail implements OrderDetail {
  const _OrderDetail({
    required this.id,
    required this.status,
    required this.version,
    required this.totalMinor,
    required this.createdAt,
    required this.updatedAt,
    this.currency = 'THB',
    this.lineCount = 0,
    this.itemCount = 0,
    this.primaryItem,
    this.playerId,
    this.channel,
    List<OrderLine> items = const <OrderLine>[],
    List<OrderHistoryEntry> history = const <OrderHistoryEntry>[],
    List<OrderNote> notes = const <OrderNote>[],
    List<OrderAttachment> attachments = const <OrderAttachment>[],
  }) : _items = items,
       _history = history,
       _notes = notes,
       _attachments = attachments;
  factory _OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final int version;
  @override
  final int totalMinor;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final int lineCount;
  @override
  @JsonKey()
  final int itemCount;
  @override
  final PrimaryItem? primaryItem;
  @override
  final String? playerId;
  @override
  final String? channel;
  final List<OrderLine> _items;
  @override
  @JsonKey()
  List<OrderLine> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    return EqualUnmodifiableListView(_items);
  }

  final List<OrderHistoryEntry> _history;
  @override
  @JsonKey()
  List<OrderHistoryEntry> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    return EqualUnmodifiableListView(_history);
  }

  final List<OrderNote> _notes;
  @override
  @JsonKey()
  List<OrderNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    return EqualUnmodifiableListView(_notes);
  }

  final List<OrderAttachment> _attachments;
  @override
  @JsonKey()
  List<OrderAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderDetailCopyWith<_OrderDetail> get copyWith =>
      __$OrderDetailCopyWithImpl<_OrderDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderDetailToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderDetail &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.totalMinor, totalMinor) ||
                other.totalMinor == totalMinor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.lineCount, lineCount) ||
                other.lineCount == lineCount) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.primaryItem, primaryItem) ||
                other.primaryItem == primaryItem) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(other.items, _items) &&
            const DeepCollectionEquality().equals(other.history, _history) &&
            const DeepCollectionEquality().equals(other.notes, _notes) &&
            const DeepCollectionEquality().equals(
              other.attachments,
              _attachments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      status,
      version,
      totalMinor,
      createdAt,
      updatedAt,
      currency,
      lineCount,
      itemCount,
      primaryItem,
      playerId,
      channel,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_history),
      const DeepCollectionEquality().hash(_notes),
      const DeepCollectionEquality().hash(_attachments),
    );
  }

  @override
  String toString() {
    return 'OrderDetail(id: $id, status: $status, version: $version, totalMinor: $totalMinor, createdAt: $createdAt, updatedAt: $updatedAt, currency: $currency, lineCount: $lineCount, itemCount: $itemCount, primaryItem: $primaryItem, playerId: $playerId, channel: $channel, items: $items, history: $history, notes: $notes, attachments: $attachments)';
  }
}

abstract mixin class _$OrderDetailCopyWith<$Res>
    implements $OrderDetailCopyWith<$Res> {
  factory _$OrderDetailCopyWith(
    _OrderDetail value,
    $Res Function(_OrderDetail) _then,
  ) = __$OrderDetailCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String status,
    int version,
    int totalMinor,
    DateTime createdAt,
    DateTime updatedAt,
    String currency,
    int lineCount,
    int itemCount,
    PrimaryItem? primaryItem,
    String? playerId,
    String? channel,
    List<OrderLine> items,
    List<OrderHistoryEntry> history,
    List<OrderNote> notes,
    List<OrderAttachment> attachments,
  });

  @override
  $PrimaryItemCopyWith<$Res>? get primaryItem;
}

class __$OrderDetailCopyWithImpl<$Res> implements _$OrderDetailCopyWith<$Res> {
  __$OrderDetailCopyWithImpl(this._self, this._then);

  final _OrderDetail _self;
  final $Res Function(_OrderDetail) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? version = null,
    Object? totalMinor = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currency = null,
    Object? lineCount = null,
    Object? itemCount = null,
    Object? primaryItem = freezed,
    Object? playerId = freezed,
    Object? channel = freezed,
    Object? items = null,
    Object? history = null,
    Object? notes = null,
    Object? attachments = null,
  }) {
    return _then(
      _OrderDetail(
        id: null == id ? _self.id : id as String,
        status: null == status ? _self.status : status as String,
        version: null == version ? _self.version : version as int,
        totalMinor: null == totalMinor ? _self.totalMinor : totalMinor as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        updatedAt: null == updatedAt ? _self.updatedAt : updatedAt as DateTime,
        currency: null == currency ? _self.currency : currency as String,
        lineCount: null == lineCount ? _self.lineCount : lineCount as int,
        itemCount: null == itemCount ? _self.itemCount : itemCount as int,
        primaryItem: freezed == primaryItem
            ? _self.primaryItem
            : primaryItem as PrimaryItem?,
        playerId: freezed == playerId ? _self.playerId : playerId as String?,
        channel: freezed == channel ? _self.channel : channel as String?,
        items: null == items ? _self._items : items as List<OrderLine>,
        history: null == history
            ? _self._history
            : history as List<OrderHistoryEntry>,
        notes: null == notes ? _self._notes : notes as List<OrderNote>,
        attachments: null == attachments
            ? _self._attachments
            : attachments as List<OrderAttachment>,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $PrimaryItemCopyWith<$Res>? get primaryItem {
    if (_self.primaryItem == null) {
      return null;
    }

    return $PrimaryItemCopyWith<$Res>(_self.primaryItem!, (value) {
      return _then(_self.copyWith(primaryItem: value));
    });
  }
}

mixin _$OrdersPage {
  List<OrderSummary> get items;
  int get syncSeq;
  String? get nextCursor;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersPageCopyWith<OrdersPage> get copyWith =>
      _$OrdersPageCopyWithImpl<OrdersPage>(this as OrdersPage, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrdersPage;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersPage &&
            const DeepCollectionEquality().equals(other.items, _this.items) &&
            (identical(other.syncSeq, _this.syncSeq) ||
                other.syncSeq == _this.syncSeq) &&
            (identical(other.nextCursor, _this.nextCursor) ||
                other.nextCursor == _this.nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrdersPage;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.items),
      _this.syncSeq,
      _this.nextCursor,
    );
  }

  @override
  String toString() {
    final _this = this as OrdersPage;
    return 'OrdersPage(items: ${_this.items}, syncSeq: ${_this.syncSeq}, nextCursor: ${_this.nextCursor})';
  }
}

abstract mixin class $OrdersPageCopyWith<$Res> {
  factory $OrdersPageCopyWith(
    OrdersPage value,
    $Res Function(OrdersPage) _then,
  ) = _$OrdersPageCopyWithImpl;
  @useResult
  $Res call({List<OrderSummary> items, int syncSeq, String? nextCursor});
}

class _$OrdersPageCopyWithImpl<$Res> implements $OrdersPageCopyWith<$Res> {
  _$OrdersPageCopyWithImpl(this._self, this._then);

  final OrdersPage _self;
  final $Res Function(OrdersPage) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? syncSeq = null,
    Object? nextCursor = freezed,
  }) {
    return _then(
      OrdersPage(
        items: null == items ? _self.items : items as List<OrderSummary>,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
        nextCursor: freezed == nextCursor
            ? _self.nextCursor
            : nextCursor as String?,
      ),
    );
  }
}

extension OrdersPagePatterns on OrdersPage {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrdersPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrdersPage() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrdersPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersPage():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrdersPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersPage() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<OrderSummary> items, int syncSeq, String? nextCursor)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrdersPage() when $default != null:
        return $default(_that.items, _that.syncSeq, _that.nextCursor);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<OrderSummary> items, int syncSeq, String? nextCursor)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersPage():
        return $default(_that.items, _that.syncSeq, _that.nextCursor);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      List<OrderSummary> items,
      int syncSeq,
      String? nextCursor,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersPage() when $default != null:
        return $default(_that.items, _that.syncSeq, _that.nextCursor);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrdersPage implements OrdersPage {
  const _OrdersPage({
    required List<OrderSummary> items,
    required this.syncSeq,
    this.nextCursor,
  }) : _items = items;
  factory _OrdersPage.fromJson(Map<String, dynamic> json) =>
      _$OrdersPageFromJson(json);

  final List<OrderSummary> _items;
  @override
  List<OrderSummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int syncSeq;
  @override
  final String? nextCursor;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersPageCopyWith<_OrdersPage> get copyWith =>
      __$OrdersPageCopyWithImpl<_OrdersPage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersPageToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersPage &&
            const DeepCollectionEquality().equals(other.items, _items) &&
            (identical(other.syncSeq, syncSeq) || other.syncSeq == syncSeq) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      syncSeq,
      nextCursor,
    );
  }

  @override
  String toString() {
    return 'OrdersPage(items: $items, syncSeq: $syncSeq, nextCursor: $nextCursor)';
  }
}

abstract mixin class _$OrdersPageCopyWith<$Res>
    implements $OrdersPageCopyWith<$Res> {
  factory _$OrdersPageCopyWith(
    _OrdersPage value,
    $Res Function(_OrdersPage) _then,
  ) = __$OrdersPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<OrderSummary> items, int syncSeq, String? nextCursor});
}

class __$OrdersPageCopyWithImpl<$Res> implements _$OrdersPageCopyWith<$Res> {
  __$OrdersPageCopyWithImpl(this._self, this._then);

  final _OrdersPage _self;
  final $Res Function(_OrdersPage) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? syncSeq = null,
    Object? nextCursor = freezed,
  }) {
    return _then(
      _OrdersPage(
        items: null == items ? _self._items : items as List<OrderSummary>,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
        nextCursor: freezed == nextCursor
            ? _self.nextCursor
            : nextCursor as String?,
      ),
    );
  }
}

mixin _$OrderChange {
  int get seq;
  String get type;
  OrderSummary? get order;
  String? get id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderChangeCopyWith<OrderChange> get copyWith =>
      _$OrderChangeCopyWithImpl<OrderChange>(this as OrderChange, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrderChange;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderChange &&
            (identical(other.seq, _this.seq) || other.seq == _this.seq) &&
            (identical(other.type, _this.type) || other.type == _this.type) &&
            (identical(other.order, _this.order) ||
                other.order == _this.order) &&
            (identical(other.id, _this.id) || other.id == _this.id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrderChange;
    return Object.hash(
      runtimeType,
      _this.seq,
      _this.type,
      _this.order,
      _this.id,
    );
  }

  @override
  String toString() {
    final _this = this as OrderChange;
    return 'OrderChange(seq: ${_this.seq}, type: ${_this.type}, order: ${_this.order}, id: ${_this.id})';
  }
}

abstract mixin class $OrderChangeCopyWith<$Res> {
  factory $OrderChangeCopyWith(
    OrderChange value,
    $Res Function(OrderChange) _then,
  ) = _$OrderChangeCopyWithImpl;
  @useResult
  $Res call({int seq, String type, OrderSummary? order, String? id});

  $OrderSummaryCopyWith<$Res>? get order;
}

class _$OrderChangeCopyWithImpl<$Res> implements $OrderChangeCopyWith<$Res> {
  _$OrderChangeCopyWithImpl(this._self, this._then);

  final OrderChange _self;
  final $Res Function(OrderChange) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seq = null,
    Object? type = null,
    Object? order = freezed,
    Object? id = freezed,
  }) {
    return _then(
      OrderChange(
        seq: null == seq ? _self.seq : seq as int,
        type: null == type ? _self.type : type as String,
        order: freezed == order ? _self.order : order as OrderSummary?,
        id: freezed == id ? _self.id : id as String?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderSummaryCopyWith<$Res>? get order {
    if (_self.order == null) {
      return null;
    }

    return $OrderSummaryCopyWith<$Res>(_self.order!, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

extension OrderChangePatterns on OrderChange {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderChange value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderChange() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderChange value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderChange():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderChange value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderChange() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int seq, String type, OrderSummary? order, String? id)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderChange() when $default != null:
        return $default(_that.seq, _that.type, _that.order, _that.id);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int seq, String type, OrderSummary? order, String? id)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderChange():
        return $default(_that.seq, _that.type, _that.order, _that.id);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int seq, String type, OrderSummary? order, String? id)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderChange() when $default != null:
        return $default(_that.seq, _that.type, _that.order, _that.id);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrderChange implements OrderChange {
  const _OrderChange({
    required this.seq,
    required this.type,
    this.order,
    this.id,
  });
  factory _OrderChange.fromJson(Map<String, dynamic> json) =>
      _$OrderChangeFromJson(json);

  @override
  final int seq;
  @override
  final String type;
  @override
  final OrderSummary? order;
  @override
  final String? id;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderChangeCopyWith<_OrderChange> get copyWith =>
      __$OrderChangeCopyWithImpl<_OrderChange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderChangeToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderChange &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, seq, type, order, id);
  }

  @override
  String toString() {
    return 'OrderChange(seq: $seq, type: $type, order: $order, id: $id)';
  }
}

abstract mixin class _$OrderChangeCopyWith<$Res>
    implements $OrderChangeCopyWith<$Res> {
  factory _$OrderChangeCopyWith(
    _OrderChange value,
    $Res Function(_OrderChange) _then,
  ) = __$OrderChangeCopyWithImpl;
  @override
  @useResult
  $Res call({int seq, String type, OrderSummary? order, String? id});

  @override
  $OrderSummaryCopyWith<$Res>? get order;
}

class __$OrderChangeCopyWithImpl<$Res> implements _$OrderChangeCopyWith<$Res> {
  __$OrderChangeCopyWithImpl(this._self, this._then);

  final _OrderChange _self;
  final $Res Function(_OrderChange) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? seq = null,
    Object? type = null,
    Object? order = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _OrderChange(
        seq: null == seq ? _self.seq : seq as int,
        type: null == type ? _self.type : type as String,
        order: freezed == order ? _self.order : order as OrderSummary?,
        id: freezed == id ? _self.id : id as String?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderSummaryCopyWith<$Res>? get order {
    if (_self.order == null) {
      return null;
    }

    return $OrderSummaryCopyWith<$Res>(_self.order!, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

mixin _$ChangesPage {
  List<OrderChange> get changes;
  int get nextSince;
  bool get hasMore;
  int get syncSeq;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChangesPageCopyWith<ChangesPage> get copyWith =>
      _$ChangesPageCopyWithImpl<ChangesPage>(this as ChangesPage, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as ChangesPage;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChangesPage &&
            const DeepCollectionEquality().equals(
              other.changes,
              _this.changes,
            ) &&
            (identical(other.nextSince, _this.nextSince) ||
                other.nextSince == _this.nextSince) &&
            (identical(other.hasMore, _this.hasMore) ||
                other.hasMore == _this.hasMore) &&
            (identical(other.syncSeq, _this.syncSeq) ||
                other.syncSeq == _this.syncSeq));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as ChangesPage;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.changes),
      _this.nextSince,
      _this.hasMore,
      _this.syncSeq,
    );
  }

  @override
  String toString() {
    final _this = this as ChangesPage;
    return 'ChangesPage(changes: ${_this.changes}, nextSince: ${_this.nextSince}, hasMore: ${_this.hasMore}, syncSeq: ${_this.syncSeq})';
  }
}

abstract mixin class $ChangesPageCopyWith<$Res> {
  factory $ChangesPageCopyWith(
    ChangesPage value,
    $Res Function(ChangesPage) _then,
  ) = _$ChangesPageCopyWithImpl;
  @useResult
  $Res call({
    List<OrderChange> changes,
    int nextSince,
    bool hasMore,
    int syncSeq,
  });
}

class _$ChangesPageCopyWithImpl<$Res> implements $ChangesPageCopyWith<$Res> {
  _$ChangesPageCopyWithImpl(this._self, this._then);

  final ChangesPage _self;
  final $Res Function(ChangesPage) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changes = null,
    Object? nextSince = null,
    Object? hasMore = null,
    Object? syncSeq = null,
  }) {
    return _then(
      ChangesPage(
        changes: null == changes ? _self.changes : changes as List<OrderChange>,
        nextSince: null == nextSince ? _self.nextSince : nextSince as int,
        hasMore: null == hasMore ? _self.hasMore : hasMore as bool,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
      ),
    );
  }
}

extension ChangesPagePatterns on ChangesPage {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChangesPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangesPage() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChangesPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangesPage():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChangesPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangesPage() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      List<OrderChange> changes,
      int nextSince,
      bool hasMore,
      int syncSeq,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangesPage() when $default != null:
        return $default(
          _that.changes,
          _that.nextSince,
          _that.hasMore,
          _that.syncSeq,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      List<OrderChange> changes,
      int nextSince,
      bool hasMore,
      int syncSeq,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangesPage():
        return $default(
          _that.changes,
          _that.nextSince,
          _that.hasMore,
          _that.syncSeq,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      List<OrderChange> changes,
      int nextSince,
      bool hasMore,
      int syncSeq,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangesPage() when $default != null:
        return $default(
          _that.changes,
          _that.nextSince,
          _that.hasMore,
          _that.syncSeq,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _ChangesPage implements ChangesPage {
  const _ChangesPage({
    required List<OrderChange> changes,
    required this.nextSince,
    required this.hasMore,
    required this.syncSeq,
  }) : _changes = changes;
  factory _ChangesPage.fromJson(Map<String, dynamic> json) =>
      _$ChangesPageFromJson(json);

  final List<OrderChange> _changes;
  @override
  List<OrderChange> get changes {
    if (_changes is EqualUnmodifiableListView) return _changes;
    return EqualUnmodifiableListView(_changes);
  }

  @override
  final int nextSince;
  @override
  final bool hasMore;
  @override
  final int syncSeq;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChangesPageCopyWith<_ChangesPage> get copyWith =>
      __$ChangesPageCopyWithImpl<_ChangesPage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChangesPageToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChangesPage &&
            const DeepCollectionEquality().equals(other.changes, _changes) &&
            (identical(other.nextSince, nextSince) ||
                other.nextSince == nextSince) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.syncSeq, syncSeq) || other.syncSeq == syncSeq));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_changes),
      nextSince,
      hasMore,
      syncSeq,
    );
  }

  @override
  String toString() {
    return 'ChangesPage(changes: $changes, nextSince: $nextSince, hasMore: $hasMore, syncSeq: $syncSeq)';
  }
}

abstract mixin class _$ChangesPageCopyWith<$Res>
    implements $ChangesPageCopyWith<$Res> {
  factory _$ChangesPageCopyWith(
    _ChangesPage value,
    $Res Function(_ChangesPage) _then,
  ) = __$ChangesPageCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<OrderChange> changes,
    int nextSince,
    bool hasMore,
    int syncSeq,
  });
}

class __$ChangesPageCopyWithImpl<$Res> implements _$ChangesPageCopyWith<$Res> {
  __$ChangesPageCopyWithImpl(this._self, this._then);

  final _ChangesPage _self;
  final $Res Function(_ChangesPage) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? changes = null,
    Object? nextSince = null,
    Object? hasMore = null,
    Object? syncSeq = null,
  }) {
    return _then(
      _ChangesPage(
        changes: null == changes
            ? _self._changes
            : changes as List<OrderChange>,
        nextSince: null == nextSince ? _self.nextSince : nextSince as int,
        hasMore: null == hasMore ? _self.hasMore : hasMore as bool,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
      ),
    );
  }
}

mixin _$OrdersSummary {
  Map<String, int> get counts;
  int get total;
  int get syncSeq;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersSummaryCopyWith<OrdersSummary> get copyWith =>
      _$OrdersSummaryCopyWithImpl<OrdersSummary>(
        this as OrdersSummary,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as OrdersSummary;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersSummary &&
            const DeepCollectionEquality().equals(other.counts, _this.counts) &&
            (identical(other.total, _this.total) ||
                other.total == _this.total) &&
            (identical(other.syncSeq, _this.syncSeq) ||
                other.syncSeq == _this.syncSeq));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as OrdersSummary;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.counts),
      _this.total,
      _this.syncSeq,
    );
  }

  @override
  String toString() {
    final _this = this as OrdersSummary;
    return 'OrdersSummary(counts: ${_this.counts}, total: ${_this.total}, syncSeq: ${_this.syncSeq})';
  }
}

abstract mixin class $OrdersSummaryCopyWith<$Res> {
  factory $OrdersSummaryCopyWith(
    OrdersSummary value,
    $Res Function(OrdersSummary) _then,
  ) = _$OrdersSummaryCopyWithImpl;
  @useResult
  $Res call({Map<String, int> counts, int total, int syncSeq});
}

class _$OrdersSummaryCopyWithImpl<$Res>
    implements $OrdersSummaryCopyWith<$Res> {
  _$OrdersSummaryCopyWithImpl(this._self, this._then);

  final OrdersSummary _self;
  final $Res Function(OrdersSummary) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? total = null,
    Object? syncSeq = null,
  }) {
    return _then(
      OrdersSummary(
        counts: null == counts ? _self.counts : counts as Map<String, int>,
        total: null == total ? _self.total : total as int,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
      ),
    );
  }
}

extension OrdersSummaryPatterns on OrdersSummary {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrdersSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrdersSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrdersSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Map<String, int> counts, int total, int syncSeq)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary() when $default != null:
        return $default(_that.counts, _that.total, _that.syncSeq);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Map<String, int> counts, int total, int syncSeq) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary():
        return $default(_that.counts, _that.total, _that.syncSeq);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(Map<String, int> counts, int total, int syncSeq)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrdersSummary() when $default != null:
        return $default(_that.counts, _that.total, _that.syncSeq);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _OrdersSummary implements OrdersSummary {
  const _OrdersSummary({
    required Map<String, int> counts,
    required this.total,
    required this.syncSeq,
  }) : _counts = counts;
  factory _OrdersSummary.fromJson(Map<String, dynamic> json) =>
      _$OrdersSummaryFromJson(json);

  final Map<String, int> _counts;
  @override
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    return EqualUnmodifiableMapView(_counts);
  }

  @override
  final int total;
  @override
  final int syncSeq;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersSummaryCopyWith<_OrdersSummary> get copyWith =>
      __$OrdersSummaryCopyWithImpl<_OrdersSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersSummaryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersSummary &&
            const DeepCollectionEquality().equals(other.counts, _counts) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.syncSeq, syncSeq) || other.syncSeq == syncSeq));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_counts),
      total,
      syncSeq,
    );
  }

  @override
  String toString() {
    return 'OrdersSummary(counts: $counts, total: $total, syncSeq: $syncSeq)';
  }
}

abstract mixin class _$OrdersSummaryCopyWith<$Res>
    implements $OrdersSummaryCopyWith<$Res> {
  factory _$OrdersSummaryCopyWith(
    _OrdersSummary value,
    $Res Function(_OrdersSummary) _then,
  ) = __$OrdersSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({Map<String, int> counts, int total, int syncSeq});
}

class __$OrdersSummaryCopyWithImpl<$Res>
    implements _$OrdersSummaryCopyWith<$Res> {
  __$OrdersSummaryCopyWithImpl(this._self, this._then);

  final _OrdersSummary _self;
  final $Res Function(_OrdersSummary) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? counts = null,
    Object? total = null,
    Object? syncSeq = null,
  }) {
    return _then(
      _OrdersSummary(
        counts: null == counts ? _self._counts : counts as Map<String, int>,
        total: null == total ? _self.total : total as int,
        syncSeq: null == syncSeq ? _self.syncSeq : syncSeq as int,
      ),
    );
  }
}
