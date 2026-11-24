import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/realtime/application/realtime_providers.dart';
import 'package:inblack_orders/features/realtime/data/realtime_client.dart';

class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status =
        ref.watch(connectionStatusProvider).value ?? ConnectionStatus.offline;
    final scheme = Theme.of(context).colorScheme;
    final (label, icon, color) = switch (status) {
      ConnectionStatus.live => (
        context.l10n.connLive,
        Icons.circle,
        const Color(0xFF1B873F),
      ),
      ConnectionStatus.reconnecting => (
        context.l10n.connReconnecting,
        Icons.sync,
        scheme.onSurfaceVariant,
      ),
      ConnectionStatus.offline => (
        context.l10n.connOffline,
        Icons.cloud_off,
        scheme.onSurfaceVariant,
      ),
    };
    return Semantics(
      label: context.l10n.connSemantics(label),
      liveRegion: true,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: status == ConnectionStatus.live ? 10 : 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: status == ConnectionStatus.live
                    ? scheme.onSurface
                    : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
