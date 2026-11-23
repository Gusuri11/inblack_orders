part of 'order_detail_controller.dart';

T _$identity<T>(T value) => value;

mixin _$OrderDetailState {
  OrderDetail? get detail;
  String? get liveStatus;
  int? get liveVersion;
  bool get loading;
  bool get refreshing;
  bool get notFound;
  bool get deleted;
  ApiException? get error;
  List<OutboxRow> get outbox;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailStateCopyWith<OrderDetailState> get copyWith =>
      _$OrderDetailStateCopyWithImpl<OrderDetailState>(
        this as OrderDetailState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as OrderDetailState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetailState &&
            (identical(other.detail, _this.detail) ||
                other.detail == _this.detail) &&
            (identical(other.liveStatus, _this.liveStatus) ||
                other.liveStatus == _this.liveStatus) &&
            (identical(other.liveVersion, _this.liveVersion) ||
                other.liveVersion == _this.liveVersion) &&
            (identical(other.loading, _this.loading) ||
                other.loading == _this.loading) &&
            (identical(other.refreshing, _this.refreshing) ||
                other.refreshing == _this.refreshing) &&
            (identical(other.notFound, _this.notFound) ||
                other.notFound == _this.notFound) &&
            (identical(other.deleted, _this.deleted) ||
                other.deleted == _this.deleted) &&
            (identical(other.error, _this.error) ||
                other.error == _this.error) &&
            const DeepCollectionEquality().equals(other.outbox, _this.outbox));
  }

  @override
  int get hashCode {
    final _this = this as OrderDetailState;
    return Object.hash(
      runtimeType,
      _this.detail,
      _this.liveStatus,
      _this.liveVersion,
      _this.loading,
      _this.refreshing,
      _this.notFound,
      _this.deleted,
      _this.error,
      const DeepCollectionEquality().hash(_this.outbox),
    );
  }

  @override
  String toString() {
    final _this = this as OrderDetailState;
    return 'OrderDetailState(detail: ${_this.detail}, liveStatus: ${_this.liveStatus}, liveVersion: ${_this.liveVersion}, loading: ${_this.loading}, refreshing: ${_this.refreshing}, notFound: ${_this.notFound}, deleted: ${_this.deleted}, error: ${_this.error}, outbox: ${_this.outbox})';
  }
}

abstract mixin class $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailStateCopyWith(
    OrderDetailState value,
    $Res Function(OrderDetailState) _then,
  ) = _$OrderDetailStateCopyWithImpl;
  @useResult
  $Res call({
    OrderDetail? detail,
    String? liveStatus,
    int? liveVersion,
    bool loading,
    bool refreshing,
    bool notFound,
    bool deleted,
    ApiException? error,
    List<OutboxRow> outbox,
  });

  $OrderDetailCopyWith<$Res>? get detail;
}

class _$OrderDetailStateCopyWithImpl<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  _$OrderDetailStateCopyWithImpl(this._self, this._then);

  final OrderDetailState _self;
  final $Res Function(OrderDetailState) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detail = freezed,
    Object? liveStatus = freezed,
    Object? liveVersion = freezed,
    Object? loading = null,
    Object? refreshing = null,
    Object? notFound = null,
    Object? deleted = null,
    Object? error = freezed,
    Object? outbox = null,
  }) {
    return _then(
      OrderDetailState(
        detail: freezed == detail ? _self.detail : detail as OrderDetail?,
        liveStatus: freezed == liveStatus
            ? _self.liveStatus
            : liveStatus as String?,
        liveVersion: freezed == liveVersion
            ? _self.liveVersion
            : liveVersion as int?,
        loading: null == loading ? _self.loading : loading as bool,
        refreshing: null == refreshing ? _self.refreshing : refreshing as bool,
        notFound: null == notFound ? _self.notFound : notFound as bool,
        deleted: null == deleted ? _self.deleted : deleted as bool,
        error: freezed == error ? _self.error : error as ApiException?,
        outbox: null == outbox ? _self.outbox : outbox as List<OutboxRow>,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
      return null;
    }

    return $OrderDetailCopyWith<$Res>(_self.detail!, (value) {
      return _then(_self.copyWith(detail: value));
    });
  }
}

extension OrderDetailStatePatterns on OrderDetailState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderDetailState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderDetailState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderDetailState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      OrderDetail? detail,
      String? liveStatus,
      int? liveVersion,
      bool loading,
      bool refreshing,
      bool notFound,
      bool deleted,
      ApiException? error,
      List<OutboxRow> outbox,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState() when $default != null:
        return $default(
          _that.detail,
          _that.liveStatus,
          _that.liveVersion,
          _that.loading,
          _that.refreshing,
          _that.notFound,
          _that.deleted,
          _that.error,
          _that.outbox,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      OrderDetail? detail,
      String? liveStatus,
      int? liveVersion,
      bool loading,
      bool refreshing,
      bool notFound,
      bool deleted,
      ApiException? error,
      List<OutboxRow> outbox,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState():
        return $default(
          _that.detail,
          _that.liveStatus,
          _that.liveVersion,
          _that.loading,
          _that.refreshing,
          _that.notFound,
          _that.deleted,
          _that.error,
          _that.outbox,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      OrderDetail? detail,
      String? liveStatus,
      int? liveVersion,
      bool loading,
      bool refreshing,
      bool notFound,
      bool deleted,
      ApiException? error,
      List<OutboxRow> outbox,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderDetailState() when $default != null:
        return $default(
          _that.detail,
          _that.liveStatus,
          _that.liveVersion,
          _that.loading,
          _that.refreshing,
          _that.notFound,
          _that.deleted,
          _that.error,
          _that.outbox,
        );
      case _:
        return null;
    }
  }
}

class _OrderDetailState extends OrderDetailState {
  const _OrderDetailState({
    this.detail,
    this.liveStatus,
    this.liveVersion,
    this.loading = true,
    this.refreshing = false,
    this.notFound = false,
    this.deleted = false,
    this.error,
    List<OutboxRow> outbox = const <OutboxRow>[],
  }) : _outbox = outbox,
       super._();

  @override
  final OrderDetail? detail;
  @override
  final String? liveStatus;
  @override
  final int? liveVersion;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool refreshing;
  @override
  @JsonKey()
  final bool notFound;
  @override
  @JsonKey()
  final bool deleted;
  @override
  final ApiException? error;
  final List<OutboxRow> _outbox;
  @override
  @JsonKey()
  List<OutboxRow> get outbox {
    if (_outbox is EqualUnmodifiableListView) return _outbox;
    return EqualUnmodifiableListView(_outbox);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderDetailStateCopyWith<_OrderDetailState> get copyWith =>
      __$OrderDetailStateCopyWithImpl<_OrderDetailState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderDetailState &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.liveStatus, liveStatus) ||
                other.liveStatus == liveStatus) &&
            (identical(other.liveVersion, liveVersion) ||
                other.liveVersion == liveVersion) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.refreshing, refreshing) ||
                other.refreshing == refreshing) &&
            (identical(other.notFound, notFound) ||
                other.notFound == notFound) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.outbox, _outbox));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      detail,
      liveStatus,
      liveVersion,
      loading,
      refreshing,
      notFound,
      deleted,
      error,
      const DeepCollectionEquality().hash(_outbox),
    );
  }

  @override
  String toString() {
    return 'OrderDetailState(detail: $detail, liveStatus: $liveStatus, liveVersion: $liveVersion, loading: $loading, refreshing: $refreshing, notFound: $notFound, deleted: $deleted, error: $error, outbox: $outbox)';
  }
}

abstract mixin class _$OrderDetailStateCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory _$OrderDetailStateCopyWith(
    _OrderDetailState value,
    $Res Function(_OrderDetailState) _then,
  ) = __$OrderDetailStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    OrderDetail? detail,
    String? liveStatus,
    int? liveVersion,
    bool loading,
    bool refreshing,
    bool notFound,
    bool deleted,
    ApiException? error,
    List<OutboxRow> outbox,
  });

  @override
  $OrderDetailCopyWith<$Res>? get detail;
}

class __$OrderDetailStateCopyWithImpl<$Res>
    implements _$OrderDetailStateCopyWith<$Res> {
  __$OrderDetailStateCopyWithImpl(this._self, this._then);

  final _OrderDetailState _self;
  final $Res Function(_OrderDetailState) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? detail = freezed,
    Object? liveStatus = freezed,
    Object? liveVersion = freezed,
    Object? loading = null,
    Object? refreshing = null,
    Object? notFound = null,
    Object? deleted = null,
    Object? error = freezed,
    Object? outbox = null,
  }) {
    return _then(
      _OrderDetailState(
        detail: freezed == detail ? _self.detail : detail as OrderDetail?,
        liveStatus: freezed == liveStatus
            ? _self.liveStatus
            : liveStatus as String?,
        liveVersion: freezed == liveVersion
            ? _self.liveVersion
            : liveVersion as int?,
        loading: null == loading ? _self.loading : loading as bool,
        refreshing: null == refreshing ? _self.refreshing : refreshing as bool,
        notFound: null == notFound ? _self.notFound : notFound as bool,
        deleted: null == deleted ? _self.deleted : deleted as bool,
        error: freezed == error ? _self.error : error as ApiException?,
        outbox: null == outbox ? _self._outbox : outbox as List<OutboxRow>,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
      return null;
    }

    return $OrderDetailCopyWith<$Res>(_self.detail!, (value) {
      return _then(_self.copyWith(detail: value));
    });
  }
}
