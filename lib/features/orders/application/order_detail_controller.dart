import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/data/order_detail_repository.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';

part 'order_detail_controller.freezed.dart';

@freezed
abstract class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState({
    OrderDetail? detail,
    String? liveStatus,
    int? liveVersion,
    @Default(true) bool loading,
    @Default(false) bool refreshing,
    @Default(false) bool notFound,
    @Default(false) bool deleted,
    ApiException? error,
    @Default(<OutboxRow>[]) List<OutboxRow> outbox,
  }) = _OrderDetailState;

  const OrderDetailState._();

  OutboxRow? get pendingCancel => outbox
      .where((r) => r.kind == OutboxKinds.cancel && r.isActive)
      .firstOrNull;

  OutboxRow? get conflict =>
      outbox.where((r) => r.state == OutboxStates.conflict).firstOrNull;

  List<OutboxRow> get failed =>
      outbox.where((r) => r.state == OutboxStates.failed).toList();

  List<OutboxRow> get queuedNotes =>
      outbox.where((r) => r.kind == OutboxKinds.note && r.isActive).toList();

  int? get currentVersion {
    final d = detail?.version;
    final live = liveVersion;
    if (d == null) return live;
    return live != null && live > d ? live : d;
  }

  String? get serverStatus {
    final d = detail;
    final live = liveVersion;
    if (d == null) return liveStatus;
    return live != null && live > d.version ? liveStatus ?? d.status : d.status;
  }

  String? get status =>
      pendingCancel != null ? OrderStatuses.cancelled : serverStatus;

  bool get canCancel {
    final s = serverStatus;
    return s != null &&
        OrderStatuses.cancellable.contains(s) &&
        pendingCancel == null &&
        conflict == null &&
        !deleted;
  }
}

final orderDetailRepositoryProvider = Provider<OrderDetailRepository>((ref) {
  return OrderDetailRepository(
    api: ref.watch(ordersApiProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

final refetchDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 300),
);

final NotifierProviderFamily<OrderDetailController, OrderDetailState, String>
orderDetailControllerProvider = NotifierProvider.autoDispose
    .family<OrderDetailController, OrderDetailState, String>(
      OrderDetailController.new,
    );

class OrderDetailController extends Notifier<OrderDetailState> {
  OrderDetailController(this.orderId);

  final String orderId;

  StreamSubscription<OrderDetail?>? _detailSub;
  StreamSubscription<OrderRow?>? _rowSub;
  StreamSubscription<List<OutboxRow>>? _outboxSub;
  Timer? _refetch;
  bool _hadContent = false;
  bool _fetching = false;

  OrderDetailRepository get _repo => ref.read(orderDetailRepositoryProvider);

  @override
  OrderDetailState build() {
    ref.onDispose(() {
      unawaited(_detailSub?.cancel());
      unawaited(_rowSub?.cancel());
      unawaited(_outboxSub?.cancel());
      _refetch?.cancel();
    });
    _detailSub = _repo.watch(orderId).listen(_onDetail);
    _rowSub = _repo.watchSummary(orderId).listen(_onRow);
    _outboxSub = ref
        .read(outboxRepositoryProvider)
        .watchForOrder(orderId)
        .listen((items) {
          if (ref.mounted) state = state.copyWith(outbox: items);
        });
    unawaited(Future.microtask(fetch));
    return const OrderDetailState();
  }

  Future<void> fetch() async {
    if (!ref.mounted || _fetching) return;
    _fetching = true;
    state = state.copyWith(
      loading: state.detail == null,
      refreshing: state.detail != null,
      error: null,
    );
    try {
      await _repo.refresh(orderId);
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, refreshing: false);
    } on OrderNotFoundException {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        notFound: !_hadContent,
        deleted: _hadContent,
      );
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, refreshing: false, error: e);
    } finally {
      _fetching = false;
    }
  }

  void _onDetail(OrderDetail? detail) {
    if (!ref.mounted) return;
    if (detail == null) {
      if (_hadContent) state = state.copyWith(deleted: true);
      return;
    }
    _hadContent = true;
    state = state.copyWith(
      detail: detail,
      loading: false,
      deleted: false,
      notFound: false,
    );
    _checkStale();
  }

  void _onRow(OrderRow? row) {
    if (!ref.mounted || row == null) return;
    state = state.copyWith(liveStatus: row.status, liveVersion: row.version);
    _checkStale();
  }

  void _checkStale() {
    final detail = state.detail;
    final live = state.liveVersion;
    if (detail == null || live == null || live <= detail.version) return;
    _refetch?.cancel();
    _refetch = Timer(ref.read(refetchDelayProvider), () => unawaited(fetch()));
  }
}
