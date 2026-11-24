import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/core/format/formatters.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

class OutboxScreen extends ConsumerWidget {
  const OutboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(outboxItemsProvider).value ?? const <OutboxRow>[];
    final actions = ref.read(outboxActionsProvider);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.outboxTitle),
        actions: [
          IconButton(
            tooltip: l.sendNow,
            icon: const Icon(Icons.send),
            onPressed: actions.drain,
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.outboxEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) =>
                  _OutboxTile(row: items[i], actions: actions),
            ),
    );
  }
}

class _OutboxTile extends StatelessWidget {
  const _OutboxTile({required this.row, required this.actions});

  final OutboxRow row;
  final OutboxActions actions;

  String _stateLabel(AppLocalizations l) => switch (row.state) {
    OutboxStates.sending => l.stateSending,
    OutboxStates.failed => l.stateFailed,
    OutboxStates.conflict => l.stateConflict,
    _ => row.lastError == null ? l.stateQueued : l.stateRequeued,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final detail = row.kind == OutboxKinds.cancel
        ? l.reasonPrefix('${row.data['reason'] ?? ''}')
        : '${row.data['text'] ?? ''}';
    final snapshotStatus = row.snapshot?['status'] as String?;
    final canCancelAgain =
        row.state == OutboxStates.conflict &&
        snapshotStatus != null &&
        OrderStatuses.cancellable.contains(snapshotStatus);
    final canRetry =
        row.state == OutboxStates.failed &&
        (row.lastError == 'network' || row.lastError == 'server');

    return InkWell(
      onTap: () => unawaited(context.push('/orders/${row.orderId}')),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${outboxKindLabel(l, row.kind)} · ${row.orderId}',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  _stateLabel(l),
                  style: TextStyle(
                    color: row.needsAttention
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(detail, maxLines: 3, overflow: TextOverflow.ellipsis),
            if (row.lastError != null) ...[
              const SizedBox(height: 4),
              Text(
                row.state == OutboxStates.conflict && snapshotStatus != null
                    ? l.latestServerStatus(
                        OrderStatuses.info(snapshotStatus).label(l),
                      )
                    : outboxErrorMessage(l, row.lastError),
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            Text(
              l.createdAttempts(
                Formatters.dateTime(
                  row.createdAt,
                  locale: context.languageCode,
                ),
                row.attempts,
              ),
              style: theme.textTheme.bodySmall,
            ),
            if (row.needsAttention)
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 4,
                  children: [
                    if (canCancelAgain)
                      TextButton(
                        onPressed: () => unawaited(actions.cancelAgain(row.id)),
                        child: Text(l.cancelAgain),
                      ),
                    if (canRetry)
                      TextButton(
                        onPressed: () => unawaited(actions.retry(row.id)),
                        child: Text(l.retry),
                      ),
                    TextButton(
                      onPressed: () => unawaited(actions.discard(row.id)),
                      child: Text(l.discard),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OutboxAction extends ConsumerWidget {
  const OutboxAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(outboxItemsProvider).value ?? const <OutboxRow>[];
    if (items.isEmpty) return const SizedBox.shrink();
    final attention = ref.watch(outboxAttentionCountProvider);
    final label = attention > 0
        ? context.l10n.outboxFailedCount(attention)
        : context.l10n.outboxPendingCount(items.length);
    return IconButton(
      tooltip: label,
      onPressed: () => unawaited(context.push('/orders/outbox')),
      icon: Badge(
        backgroundColor: attention > 0
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.secondary,
        label: Text('${attention > 0 ? attention : items.length}'),
        child: const Icon(Icons.outbox),
      ),
    );
  }
}
