import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';

part 'orders_list_state.freezed.dart';

enum RemoteStatus { idle, loading, error }

@freezed
abstract class OrdersListState with _$OrdersListState {
  const factory OrdersListState({
    @Default(<String>{}) Set<String> statuses,
    @Default('') String searchText,
    @Default('') String activeQuery,
    @Default(<OrderSummary>[]) List<OrderSummary> rows,
    @Default(false) bool rowsLoaded,
    @Default(false) bool hasMoreLocal,
    @Default(false) bool canLoadMoreRemote,
    @Default(RemoteStatus.idle) RemoteStatus remote,
    ApiException? remoteError,
    @Default(false) bool syncing,
    ApiException? syncError,
    @Default(false) bool searching,
    @Default(false) bool localSearch,
    @Default(false) bool offline,
    @Default(0) int newCount,
    OrdersSummary? summary,
    DateTime? lastSyncedAt,
  }) = _OrdersListState;

  const OrdersListState._();

  bool get isFiltered => statuses.isNotEmpty || activeQuery.isNotEmpty;

  bool get showInitialLoading =>
      rows.isEmpty &&
      (!rowsLoaded || syncing || searching || remote == RemoteStatus.loading);

  ApiException? get fullScreenError {
    if (rows.isNotEmpty || showInitialLoading) return null;
    if (remote == RemoteStatus.error) return remoteError;
    if (!rowsLoaded || isFiltered) return null;
    return syncError;
  }

  bool get showEmpty =>
      rows.isEmpty && !showInitialLoading && fullScreenError == null;

  bool get hasMore => hasMoreLocal || canLoadMoreRemote;

  bool get showLocalResultsNotice =>
      localSearch || (offline && activeQuery.isNotEmpty);
}
