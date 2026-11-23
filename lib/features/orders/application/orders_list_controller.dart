import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/connectivity/network_status.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/database/order_key.dart';
import 'package:inblack_orders/core/database/orders_dao.dart';
import 'package:inblack_orders/core/database/sync_state_dao.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/orders/application/orders_list_state.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/data/order_row_mapper.dart';

final searchDebounceProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 300),
);

final NotifierProvider<OrdersListController, OrdersListState>
ordersListControllerProvider =
    NotifierProvider.autoDispose<OrdersListController, OrdersListState>(
      OrdersListController.new,
    );

enum _Mode { all, filtered, search, localSearch }

class OrdersListController extends Notifier<OrdersListState> {
  static const pageSize = 50;
  static final _nothingLoaded = OrderKey(DateTime.utc(9999), '');

  StreamSubscription<List<OrderRow>>? _rowsSub;
  StreamSubscription<int>? _newSub;
  StreamSubscription<SyncStateRow>? _syncSub;
  Timer? _debounce;

  SyncStateRow? _sync;
  int _limit = pageSize;
  int _generation = 0;
  OrderKey? _anchor;

  String? _filterCursor;
  OrderKey? _filterBoundary;
  bool _filterStarted = false;
  bool _filterComplete = false;

  List<String>? _searchIds;
  String? _searchCursor;

  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  OrdersListState build() {
    ref.onDispose(() {
      unawaited(_rowsSub?.cancel());
      unawaited(_newSub?.cancel());
      unawaited(_syncSub?.cancel());
      _debounce?.cancel();
    });
    _syncSub = _db.syncStateDao.watch().listen(_onSyncState);
    ref.listen(networkOnlineProvider, (previous, next) {
      final wasOffline = previous?.value == false;
      if (next.value ?? false) {
        if (wasOffline || state.offline) unawaited(_onBackOnline());
      } else if (next.value == false && !state.offline) {
        state = state.copyWith(offline: true);
        _resubscribe();
      }
    });
    unawaited(Future.microtask(_start));
    return const OrdersListState();
  }

  Future<void> _onBackOnline() async {
    if (!ref.mounted) return;
    if (state.rows.isEmpty && state.syncError != null) {
      await _runSync();
      return;
    }
    try {
      await ref.read(orderSyncEngineProvider).sync();
      if (ref.mounted) _markOnline();
    } on ApiException catch (e) {
      if (ref.mounted) _markFailure(e);
    }
  }

  Future<void> _start() async {
    if (!ref.mounted) return;
    unawaited(_loadSummary());
    await _runSync();
  }

  void setSearchText(String text) {
    state = state.copyWith(searchText: text);
    _debounce?.cancel();
    final query = text.trim();
    if (query == state.activeQuery) return;
    _debounce = Timer(ref.read(searchDebounceProvider), () {
      unawaited(_applyQuery(query));
    });
  }

  Future<void> clearSearch() {
    _debounce?.cancel();
    state = state.copyWith(searchText: '');
    return _applyQuery('');
  }

  Future<void> toggleStatus(String status) {
    final next = {...state.statuses};
    if (!next.remove(status)) next.add(status);
    return _setStatuses(next);
  }

  Future<void> clearStatuses() => _setStatuses({});

  void setAtTop({required bool atTop}) {
    if (atTop && _anchor != null) {
      _anchor = null;
      _resubscribe();
    } else if (!atTop && _anchor == null && state.rows.isNotEmpty) {
      final first = state.rows.first;
      _anchor = OrderKey(first.createdAt.toUtc(), first.id);
      _resubscribe();
    }
  }

  void showNewest() {
    if (_anchor == null) return;
    _anchor = null;
    _resubscribe();
  }

  Future<void> loadMore() async {
    if (state.hasMoreLocal) {
      _limit += pageSize;
      _resubscribe();
      return;
    }
    if (state.remote == RemoteStatus.loading || !_canFetchRemote) return;

    final generation = _generation;
    state = state.copyWith(remote: RemoteStatus.loading, remoteError: null);
    try {
      switch (_mode) {
        case _Mode.all:
          await ref.read(orderSyncEngineProvider).loadOlder();
        case _Mode.filtered:
          await _fetchFilteredPage();
        case _Mode.search:
          await _fetchSearchPage();
        case _Mode.localSearch:
          break;
      }
      if (!ref.mounted || generation != _generation) return;
      _markOnline();
      _limit += pageSize;
      state = state.copyWith(remote: RemoteStatus.idle);
      _resubscribe();
    } on ApiException catch (e) {
      if (!ref.mounted || generation != _generation) return;
      _markFailure(e);
      state = state.copyWith(remote: RemoteStatus.error, remoteError: e);
    }
  }

  Future<void> retry() async {
    if (state.rows.isEmpty && state.syncError != null && !state.isFiltered) {
      await _runSync();
      return;
    }
    if (_mode == _Mode.search && _searchIds == null) {
      await _applyQuery(state.activeQuery, force: true);
      return;
    }
    state = state.copyWith(remote: RemoteStatus.idle, remoteError: null);
    await loadMore();
  }

  Future<ApiException?> refresh() async {
    _anchor = null;
    ApiException? failure;
    Future<void> list() async {
      if (state.activeQuery.isNotEmpty) {
        await _applyQuery(state.activeQuery, force: true);
        failure = state.remote == RemoteStatus.error ? state.remoteError : null;
        return;
      }
      try {
        await ref.read(orderSyncEngineProvider).sync();
        _markOnline();
      } on ApiException catch (e) {
        _markFailure(e);
        failure = e;
      }
    }

    await Future.wait([_loadSummary(), list()]);
    if (ref.mounted) _resubscribe();
    return failure;
  }

  Future<void> _runSync() async {
    state = state.copyWith(syncing: true, syncError: null);
    try {
      await ref.read(orderSyncEngineProvider).sync();
      if (!ref.mounted) return;
      _markOnline();
      state = state.copyWith(syncing: false);
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      _markFailure(e);
      state = state.copyWith(syncing: false, syncError: e);
    }
    _resubscribe();
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await ref.read(ordersRepositoryProvider).summary();
      if (ref.mounted) state = state.copyWith(summary: summary);
    } on ApiException catch (e) {
      if (ref.mounted) _markFailure(e);
    }
  }

  Future<void> _setStatuses(Set<String> statuses) async {
    state = state.copyWith(
      statuses: statuses,
      rows: const [],
      rowsLoaded: false,
      remote: RemoteStatus.idle,
      remoteError: null,
    );
    if (state.activeQuery.isNotEmpty) {
      await _applyQuery(state.activeQuery, force: true);
    } else {
      _resetPaging();
      _resubscribe();
    }
  }

  Future<void> _applyQuery(String query, {bool force = false}) async {
    if (!ref.mounted) return;
    if (!force && query == state.activeQuery) return;
    _resetPaging();
    final generation = _generation;
    state = state.copyWith(
      activeQuery: query,
      localSearch: false,
      searching: query.isNotEmpty,
      remote: RemoteStatus.idle,
      remoteError: null,
      rows: const [],
      rowsLoaded: false,
    );
    _resubscribe();
    if (query.isEmpty) return;

    try {
      final page = await ref
          .read(ordersRepositoryProvider)
          .fetchPage(statuses: _statusList, query: query);
      if (!ref.mounted || generation != _generation) return;
      _searchIds = [for (final o in page.items) o.id];
      _searchCursor = page.nextCursor;
      _markOnline();
      state = state.copyWith(searching: false);
    } on ApiException catch (e) {
      if (!ref.mounted || generation != _generation) return;
      _markFailure(e);
      state = e.isNetworkError
          ? state.copyWith(searching: false, localSearch: true)
          : state.copyWith(
              searching: false,
              remote: RemoteStatus.error,
              remoteError: e,
            );
    }
    _resubscribe();
  }

  Future<void> _fetchFilteredPage() async {
    final page = await ref
        .read(ordersRepositoryProvider)
        .fetchPage(statuses: _statusList, cursor: _filterCursor);
    _filterStarted = true;
    _applyFilteredPage(page);
  }

  void _applyFilteredPage(OrdersPage page) {
    _filterCursor = page.nextCursor;
    _filterComplete = page.nextCursor == null;
    if (page.items.isNotEmpty) {
      final last = page.items.last;
      _filterBoundary = OrderKey(last.createdAt.toUtc(), last.id);
    }
  }

  Future<void> _fetchSearchPage() async {
    final page = await ref
        .read(ordersRepositoryProvider)
        .fetchPage(
          statuses: _statusList,
          query: state.activeQuery,
          cursor: _searchCursor,
        );
    _searchIds = [...?_searchIds, for (final o in page.items) o.id];
    _searchCursor = page.nextCursor;
  }

  void _onSyncState(SyncStateRow next) {
    final previous = _sync;
    _sync = next;
    if (!ref.mounted) return;
    state = state.copyWith(lastSyncedAt: next.lastSyncedAt);
    if (previous == null ||
        previous.oldestKey != next.oldestKey ||
        previous.reachedEnd != next.reachedEnd ||
        (previous.syncSeq == null) != (next.syncSeq == null)) {
      _resubscribe();
    }
  }

  void _markOnline() {
    if (state.offline) {
      state = state.copyWith(offline: false);
      _resubscribe();
    }
  }

  void _markFailure(ApiException e) {
    if (e.isNetworkError && !state.offline) {
      state = state.copyWith(offline: true);
      _resubscribe();
    }
  }

  void _resetPaging() {
    _generation++;
    _limit = pageSize;
    _anchor = null;
    _filterCursor = null;
    _filterBoundary = null;
    _filterStarted = false;
    _filterComplete = false;
    _searchIds = null;
    _searchCursor = null;
  }

  List<String> get _statusList => state.statuses.toList()..sort();

  _Mode get _mode {
    if (state.activeQuery.isNotEmpty) {
      return state.localSearch ? _Mode.localSearch : _Mode.search;
    }
    return state.statuses.isEmpty ? _Mode.all : _Mode.filtered;
  }

  bool get _syncComplete => _sync?.reachedEnd ?? false;

  bool get _canFetchRemote => switch (_mode) {
    _Mode.all => !_syncComplete,
    _Mode.filtered => !_syncComplete && !_filterComplete,
    _Mode.search => _searchIds != null && _searchCursor != null,
    _Mode.localSearch => false,
  };

  OrderKey? get _globalBound {
    final sync = _sync;
    if (sync == null || sync.syncSeq == null) return _nothingLoaded;
    if (sync.reachedEnd) return null;
    return sync.oldestKey;
  }

  OrderListFilter _filter() {
    final statuses = _statusList;
    switch (_mode) {
      case _Mode.search:
        return OrderListFilter(
          statuses: statuses,
          ids: _searchIds ?? const [],
          anchor: _anchor,
        );
      case _Mode.localSearch:
        return OrderListFilter(
          statuses: statuses,
          search: state.activeQuery,
          anchor: _anchor,
        );
      case _Mode.all:
      case _Mode.filtered:
        final global = _globalBound;
        final OrderKey? bound;
        if (global == _nothingLoaded) {
          bound = global;
        } else if (state.offline || global == null) {
          bound = null;
        } else if (_mode == _Mode.all) {
          bound = global;
        } else if (_filterComplete) {
          bound = null;
        } else {
          bound = _filterStarted
              ? OrderKey.older(global, _filterBoundary)
              : global;
        }
        return OrderListFilter(
          statuses: statuses,
          olderBound: bound,
          anchor: _anchor,
        );
    }
  }

  void _resubscribe() {
    if (!ref.mounted) return;
    final filter = _filter();
    final dao = _db.ordersDao;
    unawaited(_rowsSub?.cancel());
    unawaited(_newSub?.cancel());
    _newSub = null;

    _rowsSub = dao.watchList(filter, limit: _limit + 1).listen((rows) {
      if (!ref.mounted) return;
      final more = rows.length > _limit;
      state = state.copyWith(
        rows: [for (final r in rows.take(_limit)) r.toSummary()],
        rowsLoaded: true,
        hasMoreLocal: more,
        canLoadMoreRemote: _canFetchRemote,
      );
      _maybeFill();
    });

    final anchor = _anchor;
    if (anchor == null) {
      state = state.copyWith(newCount: 0);
    } else {
      _newSub = dao.watchNewerThan(filter, anchor).listen((count) {
        if (ref.mounted) state = state.copyWith(newCount: count);
      });
    }
  }

  void _maybeFill() {
    if (state.rows.length >= _limit ||
        state.hasMoreLocal ||
        state.remote != RemoteStatus.idle ||
        state.syncing ||
        state.searching ||
        !_canFetchRemote) {
      return;
    }
    unawaited(loadMore());
  }
}
