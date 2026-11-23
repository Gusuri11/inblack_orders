import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';

class OrdersPlaceholderScreen extends ConsumerStatefulWidget {
  const OrdersPlaceholderScreen({super.key});

  @override
  ConsumerState<OrdersPlaceholderScreen> createState() =>
      _OrdersPlaceholderScreenState();
}

class _OrdersPlaceholderScreenState
    extends ConsumerState<OrdersPlaceholderScreen> {
  StreamSubscription<Object>? _sessionSub;
  bool _syncing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _sessionSub = ref
        .read(sessionManagerProvider)
        .sessionEnded
        .listen((_) => mounted ? context.go('/login') : null);
    unawaited(_sync());
  }

  @override
  void dispose() {
    unawaited(_sessionSub?.cancel());
    super.dispose();
  }

  Future<void> _sync() async {
    setState(() {
      _syncing = true;
      _error = null;
    });
    try {
      await ref.read(orderSyncEngineProvider).sync();
    } on ApiException catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(localOrderCountProvider).value ?? 0;
    final sync = ref.watch(syncStateProvider).value;
    final last = sync?.lastSyncedAt?.toLocal();

    return Scaffold(
      appBar: AppBar(title: const Text('คำสั่งซื้อ')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ในเครื่อง: $count รายการ'),
              Text('syncSeq: ${sync?.syncSeq ?? '-'}'),
              Text('อัปเดตล่าสุด: ${last ?? '-'}'),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _syncing ? null : _sync,
                style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
                child: Text(_syncing ? 'กำลัง sync…' : 'Sync'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
