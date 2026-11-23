import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/outbox_dao.dart';
import 'package:inblack_orders/features/orders/application/order_detail_controller.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/order_tile.dart';
import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';
import 'package:inblack_orders/features/outbox/data/outbox_repository.dart';

const maxReasonLength = 200;
const maxNoteLength = 500;

Future<String?> showCancelDialog(BuildContext context, String orderId) {
  return showDialog<String>(
    context: context,
    builder: (_) => _CancelDialog(orderId: orderId),
  );
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog({required this.orderId});

  final String orderId;

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _reason = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _reason.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'กรุณาระบุเหตุผล');
      return;
    }
    if (text.length > maxReasonLength) {
      setState(() => _error = 'เหตุผลยาวได้ไม่เกิน $maxReasonLength ตัวอักษร');
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ยกเลิกคำสั่งซื้อ?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'คำสั่งซื้อ ${widget.orderId} จะถูกยกเลิก และไม่สามารถย้อนกลับได้',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reason,
              autofocus: true,
              maxLength: maxReasonLength,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'เหตุผลในการยกเลิก',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ไม่ยกเลิก'),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: const Text('ยืนยันยกเลิก'),
        ),
      ],
    );
  }
}

class CancelOrderButton extends ConsumerWidget {
  const CancelOrderButton({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailControllerProvider(orderId));
    if (!state.canCancel) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('ยกเลิกคำสั่งซื้อ'),
        onPressed: () async {
          final version = state.currentVersion;
          final reason = await showCancelDialog(context, orderId);
          if (reason == null || version == null) return;
          await ref
              .read(outboxActionsProvider)
              .cancelOrder(orderId: orderId, version: version, reason: reason);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'บันทึกคำขอยกเลิกแล้ว จะส่งให้อัตโนมัติเมื่อออนไลน์',
              ),
            ),
          );
        },
      ),
    );
  }
}

class OutboxBanners extends ConsumerWidget {
  const OutboxBanners({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailControllerProvider(orderId));
    final actions = ref.read(outboxActionsProvider);
    final pending = state.pendingCancel;
    final conflict = state.conflict;
    return Column(
      children: [
        if (pending != null)
          _Banner(
            icon: Icons.schedule_send,
            message: pending.lastError == null
                ? 'คำขอยกเลิกรอส่ง จะส่งให้อัตโนมัติเมื่อเชื่อมต่อได้'
                : 'คำขอยกเลิกรอส่ง (${outboxErrorMessage(pending.lastError)}) กำลังลองใหม่อัตโนมัติ',
          ),
        if (conflict != null) _ConflictCard(row: conflict, actions: actions),
        for (final row in state.failed)
          _Banner(
            icon: Icons.error_outline,
            tone: _Tone.error,
            message:
                '${outboxKindLabel(row.kind)}ไม่สำเร็จ: ${outboxErrorMessage(row.lastError)}',
            actions: [
              if (row.lastError == 'network' || row.lastError == 'server')
                TextButton(
                  onPressed: () => unawaited(actions.retry(row.id)),
                  child: const Text('ลองใหม่'),
                ),
              TextButton(
                onPressed: () => unawaited(actions.discard(row.id)),
                child: const Text('ทิ้ง'),
              ),
            ],
          ),
      ],
    );
  }
}

class _ConflictCard extends StatelessWidget {
  const _ConflictCard({required this.row, required this.actions});

  final OutboxRow row;
  final OutboxActions actions;

  @override
  Widget build(BuildContext context) {
    final snapshot = row.snapshot;
    final status = snapshot?['status'] as String?;
    final label = status == null ? 'ไม่ทราบ' : OrderStatuses.info(status).label;
    final canRetry =
        status != null && OrderStatuses.cancellable.contains(status);
    return _Banner(
      icon: Icons.sync_problem,
      tone: _Tone.error,
      message: canRetry
          ? 'สถานะคำสั่งซื้อเปลี่ยนไประหว่างรอส่ง ตอนนี้: $label ต้องการยกเลิกอีกครั้งหรือไม่?'
          : 'ยกเลิกไม่สำเร็จ เพราะสถานะเปลี่ยนเป็น $label แล้ว',
      actions: [
        if (canRetry)
          TextButton(
            onPressed: () => unawaited(actions.cancelAgain(row.id)),
            child: const Text('ยกเลิกอีกครั้ง'),
          ),
        TextButton(
          onPressed: () => unawaited(actions.discard(row.id)),
          child: Text(canRetry ? 'ไม่ต้องยกเลิก' : 'รับทราบ'),
        ),
      ],
    );
  }
}

enum _Tone { info, error }

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.message,
    this.tone = _Tone.info,
    this.actions = const [],
  });

  final IconData icon;
  final String message;
  final _Tone tone;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = tone == _Tone.error
        ? scheme.errorContainer
        : scheme.secondaryContainer;
    final fg = tone == _Tone.error
        ? scheme.onErrorContainer
        : scheme.onSecondaryContainer;
    return Semantics(
      liveRegion: true,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        color: bg,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: fg),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(message, style: TextStyle(color: fg)),
                    ),
                  ),
                ],
              ),
              if (actions.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(spacing: 4, children: actions),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteComposer extends ConsumerStatefulWidget {
  const NoteComposer({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState<NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends ConsumerState<NoteComposer> {
  final _text = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final value = _text.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'กรุณาพิมพ์ข้อความ');
      return;
    }
    if (value.length > maxNoteLength) {
      setState(() => _error = 'ยาวได้ไม่เกิน $maxNoteLength ตัวอักษร');
      return;
    }
    setState(() => _error = null);
    _text.clear();
    await ref
        .read(outboxActionsProvider)
        .addNote(orderId: widget.orderId, text: value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _text,
              maxLength: maxNoteLength,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'เขียนโน้ตถึงทีมงาน',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'ส่งโน้ต',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.send),
            onPressed: () => unawaited(_send()),
          ),
        ],
      ),
    );
  }
}

class QueuedNoteTile extends StatelessWidget {
  const QueuedNoteTile({required this.row, super.key});

  final OutboxRow row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = row.state == OutboxStates.failed;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PendingChip(label: failed ? 'ส่งไม่สำเร็จ' : 'รอส่ง'),
            const SizedBox(height: 6),
            Text('${row.data['text'] ?? ''}'),
          ],
        ),
      ),
    );
  }
}
