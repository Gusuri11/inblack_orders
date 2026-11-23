
part of 'orders_list_state.dart';


T _$identity<T>(T value) => value;
mixin _$OrdersListState {

 Set<String> get statuses; String get searchText; String get activeQuery; List<OrderSummary> get rows; bool get rowsLoaded; bool get hasMoreLocal; bool get canLoadMoreRemote; RemoteStatus get remote; ApiException? get remoteError; bool get syncing; ApiException? get syncError; bool get searching; bool get localSearch; bool get offline; int get newCount; OrdersSummary? get summary; DateTime? get lastSyncedAt;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersListStateCopyWith<OrdersListState> get copyWith => _$OrdersListStateCopyWithImpl<OrdersListState>(this as OrdersListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersListState&&const DeepCollectionEquality().equals(other.statuses, _this.statuses)&&(identical(other.searchText, _this.searchText) || other.searchText == _this.searchText)&&(identical(other.activeQuery, _this.activeQuery) || other.activeQuery == _this.activeQuery)&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&(identical(other.rowsLoaded, _this.rowsLoaded) || other.rowsLoaded == _this.rowsLoaded)&&(identical(other.hasMoreLocal, _this.hasMoreLocal) || other.hasMoreLocal == _this.hasMoreLocal)&&(identical(other.canLoadMoreRemote, _this.canLoadMoreRemote) || other.canLoadMoreRemote == _this.canLoadMoreRemote)&&(identical(other.remote, _this.remote) || other.remote == _this.remote)&&(identical(other.remoteError, _this.remoteError) || other.remoteError == _this.remoteError)&&(identical(other.syncing, _this.syncing) || other.syncing == _this.syncing)&&(identical(other.syncError, _this.syncError) || other.syncError == _this.syncError)&&(identical(other.searching, _this.searching) || other.searching == _this.searching)&&(identical(other.localSearch, _this.localSearch) || other.localSearch == _this.localSearch)&&(identical(other.offline, _this.offline) || other.offline == _this.offline)&&(identical(other.newCount, _this.newCount) || other.newCount == _this.newCount)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.lastSyncedAt, _this.lastSyncedAt) || other.lastSyncedAt == _this.lastSyncedAt));
}


@override
int get hashCode {
  final _this = this as OrdersListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.statuses),_this.searchText,_this.activeQuery,const DeepCollectionEquality().hash(_this.rows),_this.rowsLoaded,_this.hasMoreLocal,_this.canLoadMoreRemote,_this.remote,_this.remoteError,_this.syncing,_this.syncError,_this.searching,_this.localSearch,_this.offline,_this.newCount,_this.summary,_this.lastSyncedAt);
}

@override
String toString() {
  final _this = this as OrdersListState;
  return 'OrdersListState(statuses: ${_this.statuses}, searchText: ${_this.searchText}, activeQuery: ${_this.activeQuery}, rows: ${_this.rows}, rowsLoaded: ${_this.rowsLoaded}, hasMoreLocal: ${_this.hasMoreLocal}, canLoadMoreRemote: ${_this.canLoadMoreRemote}, remote: ${_this.remote}, remoteError: ${_this.remoteError}, syncing: ${_this.syncing}, syncError: ${_this.syncError}, searching: ${_this.searching}, localSearch: ${_this.localSearch}, offline: ${_this.offline}, newCount: ${_this.newCount}, summary: ${_this.summary}, lastSyncedAt: ${_this.lastSyncedAt})';
}


}

abstract mixin class $OrdersListStateCopyWith<$Res>  {
  factory $OrdersListStateCopyWith(OrdersListState value, $Res Function(OrdersListState) _then) = _$OrdersListStateCopyWithImpl;
@useResult
$Res call({
 Set<String> statuses, String searchText, String activeQuery, List<OrderSummary> rows, bool rowsLoaded, bool hasMoreLocal, bool canLoadMoreRemote, RemoteStatus remote, ApiException? remoteError, bool syncing, ApiException? syncError, bool searching, bool localSearch, bool offline, int newCount, OrdersSummary? summary, DateTime? lastSyncedAt
});


$OrdersSummaryCopyWith<$Res>? get summary;

}
class _$OrdersListStateCopyWithImpl<$Res>
    implements $OrdersListStateCopyWith<$Res> {
  _$OrdersListStateCopyWithImpl(this._self, this._then);

  final OrdersListState _self;
  final $Res Function(OrdersListState) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? statuses = null,Object? searchText = null,Object? activeQuery = null,Object? rows = null,Object? rowsLoaded = null,Object? hasMoreLocal = null,Object? canLoadMoreRemote = null,Object? remote = null,Object? remoteError = freezed,Object? syncing = null,Object? syncError = freezed,Object? searching = null,Object? localSearch = null,Object? offline = null,Object? newCount = null,Object? summary = freezed,Object? lastSyncedAt = freezed,}) {
  return _then(OrdersListState(
statuses: null == statuses ? _self.statuses : statuses
as Set<String>,searchText: null == searchText ? _self.searchText : searchText
as String,activeQuery: null == activeQuery ? _self.activeQuery : activeQuery
as String,rows: null == rows ? _self.rows : rows
as List<OrderSummary>,rowsLoaded: null == rowsLoaded ? _self.rowsLoaded : rowsLoaded
as bool,hasMoreLocal: null == hasMoreLocal ? _self.hasMoreLocal : hasMoreLocal
as bool,canLoadMoreRemote: null == canLoadMoreRemote ? _self.canLoadMoreRemote : canLoadMoreRemote
as bool,remote: null == remote ? _self.remote : remote
as RemoteStatus,remoteError: freezed == remoteError ? _self.remoteError : remoteError
as ApiException?,syncing: null == syncing ? _self.syncing : syncing
as bool,syncError: freezed == syncError ? _self.syncError : syncError
as ApiException?,searching: null == searching ? _self.searching : searching
as bool,localSearch: null == localSearch ? _self.localSearch : localSearch
as bool,offline: null == offline ? _self.offline : offline
as bool,newCount: null == newCount ? _self.newCount : newCount
as int,summary: freezed == summary ? _self.summary : summary
as OrdersSummary?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt
as DateTime?,
  ));
}
@override
@pragma('vm:prefer-inline')
$OrdersSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $OrdersSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


extension OrdersListStatePatterns on OrdersListState {

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersListState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersListState value)  $default,){
final _that = this;
switch (_that) {
case _OrdersListState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersListState value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersListState() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> statuses,  String searchText,  String activeQuery,  List<OrderSummary> rows,  bool rowsLoaded,  bool hasMoreLocal,  bool canLoadMoreRemote,  RemoteStatus remote,  ApiException? remoteError,  bool syncing,  ApiException? syncError,  bool searching,  bool localSearch,  bool offline,  int newCount,  OrdersSummary? summary,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersListState() when $default != null:
return $default(_that.statuses,_that.searchText,_that.activeQuery,_that.rows,_that.rowsLoaded,_that.hasMoreLocal,_that.canLoadMoreRemote,_that.remote,_that.remoteError,_that.syncing,_that.syncError,_that.searching,_that.localSearch,_that.offline,_that.newCount,_that.summary,_that.lastSyncedAt);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> statuses,  String searchText,  String activeQuery,  List<OrderSummary> rows,  bool rowsLoaded,  bool hasMoreLocal,  bool canLoadMoreRemote,  RemoteStatus remote,  ApiException? remoteError,  bool syncing,  ApiException? syncError,  bool searching,  bool localSearch,  bool offline,  int newCount,  OrdersSummary? summary,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _OrdersListState():
return $default(_that.statuses,_that.searchText,_that.activeQuery,_that.rows,_that.rowsLoaded,_that.hasMoreLocal,_that.canLoadMoreRemote,_that.remote,_that.remoteError,_that.syncing,_that.syncError,_that.searching,_that.localSearch,_that.offline,_that.newCount,_that.summary,_that.lastSyncedAt);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> statuses,  String searchText,  String activeQuery,  List<OrderSummary> rows,  bool rowsLoaded,  bool hasMoreLocal,  bool canLoadMoreRemote,  RemoteStatus remote,  ApiException? remoteError,  bool syncing,  ApiException? syncError,  bool searching,  bool localSearch,  bool offline,  int newCount,  OrdersSummary? summary,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrdersListState() when $default != null:
return $default(_that.statuses,_that.searchText,_that.activeQuery,_that.rows,_that.rowsLoaded,_that.hasMoreLocal,_that.canLoadMoreRemote,_that.remote,_that.remoteError,_that.syncing,_that.syncError,_that.searching,_that.localSearch,_that.offline,_that.newCount,_that.summary,_that.lastSyncedAt);case _:
  return null;

}
}

}



class _OrdersListState extends OrdersListState {
  const _OrdersListState({ Set<String> statuses = const <String>{}, this.searchText = '', this.activeQuery = '',  List<OrderSummary> rows = const <OrderSummary>[], this.rowsLoaded = false, this.hasMoreLocal = false, this.canLoadMoreRemote = false, this.remote = RemoteStatus.idle, this.remoteError, this.syncing = false, this.syncError, this.searching = false, this.localSearch = false, this.offline = false, this.newCount = 0, this.summary, this.lastSyncedAt}): _statuses = statuses,_rows = rows,super._();
  

 final  Set<String> _statuses;
@override@JsonKey() Set<String> get statuses {
  if (_statuses is EqualUnmodifiableSetView) return _statuses;
  return EqualUnmodifiableSetView(_statuses);
}

@override@JsonKey() final  String searchText;
@override@JsonKey() final  String activeQuery;
 final  List<OrderSummary> _rows;
@override@JsonKey() List<OrderSummary> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  return EqualUnmodifiableListView(_rows);
}

@override@JsonKey() final  bool rowsLoaded;
@override@JsonKey() final  bool hasMoreLocal;
@override@JsonKey() final  bool canLoadMoreRemote;
@override@JsonKey() final  RemoteStatus remote;
@override final  ApiException? remoteError;
@override@JsonKey() final  bool syncing;
@override final  ApiException? syncError;
@override@JsonKey() final  bool searching;
@override@JsonKey() final  bool localSearch;
@override@JsonKey() final  bool offline;
@override@JsonKey() final  int newCount;
@override final  OrdersSummary? summary;
@override final  DateTime? lastSyncedAt;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersListStateCopyWith<_OrdersListState> get copyWith => __$OrdersListStateCopyWithImpl<_OrdersListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersListState&&const DeepCollectionEquality().equals(other.statuses, _statuses)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.activeQuery, activeQuery) || other.activeQuery == activeQuery)&&const DeepCollectionEquality().equals(other.rows, _rows)&&(identical(other.rowsLoaded, rowsLoaded) || other.rowsLoaded == rowsLoaded)&&(identical(other.hasMoreLocal, hasMoreLocal) || other.hasMoreLocal == hasMoreLocal)&&(identical(other.canLoadMoreRemote, canLoadMoreRemote) || other.canLoadMoreRemote == canLoadMoreRemote)&&(identical(other.remote, remote) || other.remote == remote)&&(identical(other.remoteError, remoteError) || other.remoteError == remoteError)&&(identical(other.syncing, syncing) || other.syncing == syncing)&&(identical(other.syncError, syncError) || other.syncError == syncError)&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.localSearch, localSearch) || other.localSearch == localSearch)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.newCount, newCount) || other.newCount == newCount)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_statuses),searchText,activeQuery,const DeepCollectionEquality().hash(_rows),rowsLoaded,hasMoreLocal,canLoadMoreRemote,remote,remoteError,syncing,syncError,searching,localSearch,offline,newCount,summary,lastSyncedAt);
}

@override
String toString() {
    return 'OrdersListState(statuses: $statuses, searchText: $searchText, activeQuery: $activeQuery, rows: $rows, rowsLoaded: $rowsLoaded, hasMoreLocal: $hasMoreLocal, canLoadMoreRemote: $canLoadMoreRemote, remote: $remote, remoteError: $remoteError, syncing: $syncing, syncError: $syncError, searching: $searching, localSearch: $localSearch, offline: $offline, newCount: $newCount, summary: $summary, lastSyncedAt: $lastSyncedAt)';
}


}

abstract mixin class _$OrdersListStateCopyWith<$Res> implements $OrdersListStateCopyWith<$Res> {
  factory _$OrdersListStateCopyWith(_OrdersListState value, $Res Function(_OrdersListState) _then) = __$OrdersListStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> statuses, String searchText, String activeQuery, List<OrderSummary> rows, bool rowsLoaded, bool hasMoreLocal, bool canLoadMoreRemote, RemoteStatus remote, ApiException? remoteError, bool syncing, ApiException? syncError, bool searching, bool localSearch, bool offline, int newCount, OrdersSummary? summary, DateTime? lastSyncedAt
});


@override $OrdersSummaryCopyWith<$Res>? get summary;

}
class __$OrdersListStateCopyWithImpl<$Res>
    implements _$OrdersListStateCopyWith<$Res> {
  __$OrdersListStateCopyWithImpl(this._self, this._then);

  final _OrdersListState _self;
  final $Res Function(_OrdersListState) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,Object? searchText = null,Object? activeQuery = null,Object? rows = null,Object? rowsLoaded = null,Object? hasMoreLocal = null,Object? canLoadMoreRemote = null,Object? remote = null,Object? remoteError = freezed,Object? syncing = null,Object? syncError = freezed,Object? searching = null,Object? localSearch = null,Object? offline = null,Object? newCount = null,Object? summary = freezed,Object? lastSyncedAt = freezed,}) {
  return _then(_OrdersListState(
statuses: null == statuses ? _self._statuses : statuses
as Set<String>,searchText: null == searchText ? _self.searchText : searchText
as String,activeQuery: null == activeQuery ? _self.activeQuery : activeQuery
as String,rows: null == rows ? _self._rows : rows
as List<OrderSummary>,rowsLoaded: null == rowsLoaded ? _self.rowsLoaded : rowsLoaded
as bool,hasMoreLocal: null == hasMoreLocal ? _self.hasMoreLocal : hasMoreLocal
as bool,canLoadMoreRemote: null == canLoadMoreRemote ? _self.canLoadMoreRemote : canLoadMoreRemote
as bool,remote: null == remote ? _self.remote : remote
as RemoteStatus,remoteError: freezed == remoteError ? _self.remoteError : remoteError
as ApiException?,syncing: null == syncing ? _self.syncing : syncing
as bool,syncError: freezed == syncError ? _self.syncError : syncError
as ApiException?,searching: null == searching ? _self.searching : searching
as bool,localSearch: null == localSearch ? _self.localSearch : localSearch
as bool,offline: null == offline ? _self.offline : offline
as bool,newCount: null == newCount ? _self.newCount : newCount
as int,summary: freezed == summary ? _self.summary : summary
as OrdersSummary?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt
as DateTime?,
  ));
}

@override
@pragma('vm:prefer-inline')
$OrdersSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $OrdersSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

