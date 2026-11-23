import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/core/format/formatters.dart';
import 'package:inblack_orders/core/network/error_messages.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/orders/application/orders_list_controller.dart';
import 'package:inblack_orders/features/orders/application/orders_list_state.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/order_tile.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/status_filter_bar.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  StreamSubscription<Object>? _sessionSub;
  Timer? _ticker;
  bool _atTop = true;

  OrdersListController get _controller =>
      ref.read(ordersListControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _sessionSub = ref.read(sessionManagerProvider).sessionEnded.listen((_) {
      if (mounted) context.go('/login');
    });
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(_sessionSub?.cancel());
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    final atTop = position.pixels <= 8;
    if (atTop != _atTop) {
      _atTop = atTop;
      _controller.setAtTop(atTop: atTop);
    }
    if (position.extentAfter < 800) unawaited(_controller.loadMore());
  }

  Future<void> _refresh() async {
    final failure = await _controller.refresh();
    if (!mounted || failure == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('รีเฟรชไม่สำเร็จ: ${friendlyError(failure)}')),
    );
  }

  Future<void> _showNewest() async {
    _controller.showNewest();
    if (_scroll.hasClients) {
      await _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersListControllerProvider);
    final now = ref.watch(clockProvider)();

    return Scaffold(
      appBar: AppBar(title: const Text('คำสั่งซื้อ')),
      body: Column(
        children: [
          if (state.offline) _OfflineBanner(lastSyncedAt: state.lastSyncedAt),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: _SearchField(
              controller: _search,
              onChanged: _controller.setSearchText,
              onClear: () {
                _search.clear();
                unawaited(_controller.clearSearch());
              },
            ),
          ),
          StatusFilterBar(
            selected: state.statuses,
            summary: state.summary,
            onToggle: (s) => unawaited(_controller.toggleStatus(s)),
            onClear: () => unawaited(_controller.clearStatuses()),
          ),
          if (state.showLocalResultsNotice) const _LocalResultsNotice(),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: _buildBody(state, now),
                ),
                if (state.newCount > 0)
                  Positioned(
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FilledButton.tonalIcon(
                        onPressed: _showNewest,
                        icon: const Icon(Icons.arrow_upward),
                        label: Text('มี ${state.newCount} รายการใหม่'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(OrdersListState state, DateTime now) {
    if (state.showInitialLoading) {
      return const _FullScreenMessage(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('กำลังโหลดคำสั่งซื้อ…'),
          ],
        ),
      );
    }
    final error = state.fullScreenError;
    if (error != null) {
      return _FullScreenMessage(
        child: _ErrorView(
          message: friendlyError(error),
          onRetry: () => unawaited(_controller.retry()),
        ),
      );
    }
    if (state.showEmpty) {
      return _FullScreenMessage(child: _EmptyView(state: state));
    }

    return ListView.builder(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: state.rows.length + 1,
      itemBuilder: (context, index) {
        if (index == state.rows.length) {
          return _ListFooter(
            state: state,
            onRetry: () => unawaited(_controller.retry()),
          );
        }
        final order = state.rows[index];
        return OrderTile(
          key: ValueKey(order.id),
          order: order,
          now: now,
          onTap: () => unawaited(context.push('/orders/${order.id}')),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) => TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'ค้นหาเลขคำสั่งซื้อ, Player ID, ชื่อสินค้า',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'ล้างคำค้น',
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.lastSyncedAt});

  final DateTime? lastSyncedAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final last = lastSyncedAt;
    final text = last == null
        ? 'ออฟไลน์'
        : 'ออฟไลน์ · อัปเดตล่าสุดเมื่อ ${Formatters.dateTime(last)}';
    return Semantics(
      liveRegion: true,
      child: Material(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.cloud_off,
                size: 18,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: scheme.onSecondaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalResultsNotice extends StatelessWidget {
  const _LocalResultsNotice();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'แสดงผลจากข้อมูลในเครื่อง (ออฟไลน์) อาจไม่ครบทุกรายการ',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenMessage extends StatelessWidget {
  const _FullScreenMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(padding: const EdgeInsets.all(24), child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onRetry,
          style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
          child: const Text('ลองใหม่'),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.state});

  final OrdersListState state;

  @override
  Widget build(BuildContext context) {
    final String message;
    if (state.activeQuery.isNotEmpty) {
      message = 'ไม่พบคำสั่งซื้อที่ตรงกับ “${state.activeQuery}”';
    } else if (state.statuses.isNotEmpty) {
      message = 'ไม่มีคำสั่งซื้อในสถานะที่เลือก';
    } else {
      message = 'ยังไม่มีคำสั่งซื้อ';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
      ],
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.onRetry});

  final OrdersListState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final error = state.remoteError;
    if (state.remote == RemoteStatus.error && error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'โหลดเพิ่มไม่สำเร็จ: ${friendlyError(error)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 48)),
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      );
    }
    if (state.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Semantics(
            label: 'กำลังโหลดรายการเพิ่ม',
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'แสดงครบทุกรายการแล้ว',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
