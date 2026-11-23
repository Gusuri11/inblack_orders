import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/format/formatters.dart';
import 'package:inblack_orders/core/network/error_messages.dart';
import 'package:inblack_orders/features/orders/application/order_detail_controller.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/order_tile.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/status_badge.dart';
import 'package:inblack_orders/features/outbox/presentation/order_actions.dart';
import 'package:share_plus/share_plus.dart';

final shareTextProvider = Provider<Future<void> Function(String text)>(
  (ref) => (text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  },
);

String orderLink(String id) => 'inblack://orders/${Uri.encodeComponent(id)}';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: orderId));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('คัดลอกเลขคำสั่งซื้อ $orderId แล้ว')),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = orderDetailControllerProvider(orderId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    Widget body;
    final detail = state.detail;
    final error = state.error;
    if (state.notFound) {
      body = _NotFoundView(orderId: orderId);
    } else if (detail == null && state.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (detail == null) {
      body = _ErrorView(
        message: error == null
            ? 'ไม่สามารถโหลดข้อมูลได้'
            : friendlyError(error),
        onRetry: () => unawaited(controller.fetch()),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: controller.fetch,
        child: _DetailBody(
          orderId: orderId,
          detail: detail,
          status: state.status ?? detail.status,
          deleted: state.deleted,
          queuedNotes: state.queuedNotes,
          pending: state.pendingCancel != null,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(orderId, overflow: TextOverflow.ellipsis),
        actions: state.notFound
            ? null
            : [
                IconButton(
                  tooltip: 'คัดลอกเลขคำสั่งซื้อ',
                  icon: const Icon(Icons.copy),
                  onPressed: () => unawaited(_copy(context)),
                ),
                IconButton(
                  tooltip: 'แชร์ลิงก์คำสั่งซื้อ',
                  icon: const Icon(Icons.share),
                  onPressed: () => unawaited(
                    ref.read(shareTextProvider)(orderLink(orderId)),
                  ),
                ),
              ],
      ),
      body: body,
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.orderId,
    required this.detail,
    required this.status,
    required this.deleted,
    required this.queuedNotes,
    required this.pending,
  });

  final String orderId;
  final OrderDetail detail;
  final String status;
  final bool deleted;
  final List<OutboxRow> queuedNotes;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (deleted) const _DeletedBanner(),
        OutboxBanners(orderId: orderId),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(status: status),
                  if (pending) const PendingChip(),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(
                label:
                    'ยอดรวม ${Formatters.money(detail.totalMinor, currency: detail.currency)}',
                excludeSemantics: true,
                child: Text(
                  Formatters.money(
                    detail.totalMinor,
                    currency: detail.currency,
                  ),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _InfoRow(
                label: 'สั่งซื้อเมื่อ',
                value: Formatters.dateTime(detail.createdAt),
              ),
              _InfoRow(
                label: 'อัปเดตล่าสุด',
                value: Formatters.dateTime(detail.updatedAt),
              ),
              _InfoRow(label: 'Player ID', value: detail.playerId ?? '-'),
              _InfoRow(label: 'ช่องทาง', value: detail.channel ?? '-'),
            ],
          ),
        ),
        CancelOrderButton(orderId: orderId),
        _Section(
          title: 'สินค้า (${detail.items.length})',
          empty: detail.items.isEmpty ? 'ไม่มีรายการสินค้า' : null,
          children: [
            for (final item in detail.items)
              _ItemTile(item: item, currency: detail.currency),
          ],
        ),
        _Section(
          title: 'ประวัติสถานะ',
          empty: detail.history.isEmpty ? 'ยังไม่มีประวัติ' : null,
          children: [
            for (final (i, h) in detail.history.indexed)
              _TimelineTile(entry: h, last: i == detail.history.length - 1),
          ],
        ),
        _Section(
          title: 'โน้ต (${detail.notes.length + queuedNotes.length})',
          children: [
            if (detail.notes.isEmpty && queuedNotes.isEmpty)
              Text(
                'ยังไม่มีโน้ต',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            for (final n in detail.notes) _NoteTile(note: n),
            for (final q in queuedNotes) QueuedNoteTile(row: q),
            if (!deleted) NoteComposer(orderId: orderId),
          ],
        ),
        _Section(
          title: 'ไฟล์แนบ (${detail.attachments.length})',
          empty: detail.attachments.isEmpty ? 'ไม่มีไฟล์แนบ' : null,
          children: [
            for (final a in detail.attachments) _AttachmentTile(attachment: a),
          ],
        ),
      ],
    );
  }
}

class _DeletedBanner extends StatelessWidget {
  const _DeletedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: scheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: scheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'คำสั่งซื้อนี้ถูกลบออกจากระบบแล้ว ข้อมูลด้านล่างเป็นข้อมูลล่าสุดก่อนถูกลบ',
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/orders'),
                child: const Text('กลับไปหน้ารายการ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.empty});

  final String title;
  final List<Widget> children;
  final String? empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emptyText = empty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          if (emptyText != null)
            Text(
              emptyText,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            )
          else
            ...children,
          const Divider(height: 24),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MergeSemantics(
        child: Wrap(
          spacing: 8,
          children: [
            Text(
              '$label:',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            SelectableText(value),
          ],
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item, required this.currency});

  final OrderLine item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unit = Formatters.money(item.unitPriceMinor, currency: currency);
    final line = Formatters.money(
      item.unitPriceMinor * item.quantity,
      currency: currency,
    );
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumbnail(url: item.imageUrl, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: theme.textTheme.bodyLarge),
                  Text(
                    '${item.quantity} × $unit',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(line, style: theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}

String _actorLabel(String? by) => switch (by) {
  'system' => 'ระบบ',
  'customer' => 'ลูกค้า',
  'admin' => 'แอดมิน',
  'support' => 'ทีมงาน',
  null => '',
  _ => by,
};

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.entry, required this.last});

  final OrderHistoryEntry entry;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = OrderStatuses.info(entry.status);
    final colors = StatusColors.of(info.tone, theme.brightness);
    final actor = _actorLabel(entry.by);
    final note = entry.note;
    return MergeSemantics(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colors.background,
                  child: Icon(info.icon, size: 16, color: colors.foreground),
                ),
                if (!last)
                  Expanded(
                    child: Container(width: 2, color: theme.dividerColor),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.label, style: theme.textTheme.titleSmall),
                    Text(
                      [
                        Formatters.dateTime(entry.at),
                        if (actor.isNotEmpty) 'โดย$actor',
                      ].join(' · '),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (note != null && note.isNotEmpty) Text(note),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final OrderNote note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fromSupport = note.author == 'support';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: fromSupport
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: MergeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${fromSupport ? 'ทีมงาน' : 'คุณ'} · ${Formatters.dateTime(note.createdAt)}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              SelectableText(note.text),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({required this.attachment});

  final OrderAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final kb = (attachment.size / 1024).ceil();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.image_outlined),
      title: Text(attachment.contentType),
      subtitle: Text('$kb KB · ${Formatters.dateTime(attachment.createdAt)}'),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'ไม่พบคำสั่งซื้อ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'ไม่พบคำสั่งซื้อ $orderId อาจถูกลบไปแล้วหรือลิงก์ไม่ถูกต้อง',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/orders'),
              style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
              child: const Text('กลับไปหน้ารายการ'),
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
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
        ),
      ),
    );
  }
}
