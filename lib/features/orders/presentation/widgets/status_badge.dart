import 'package:flutter/material.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';

class StatusColors {
  const StatusColors(this.background, this.foreground);

  factory StatusColors.of(StatusTone tone, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (tone) {
      StatusTone.amber =>
        dark
            ? const StatusColors(Color(0xFF4A3300), Color(0xFFFFDDA0))
            : const StatusColors(Color(0xFFFFF0CC), Color(0xFF6B4500)),
      StatusTone.blue =>
        dark
            ? const StatusColors(Color(0xFF0B3260), Color(0xFFC9E1FF))
            : const StatusColors(Color(0xFFDCEBFF), Color(0xFF0B4A8F)),
      StatusTone.purple =>
        dark
            ? const StatusColors(Color(0xFF3B1F5C), Color(0xFFE6D3FF))
            : const StatusColors(Color(0xFFEFE3FF), Color(0xFF5A2C8C)),
      StatusTone.green =>
        dark
            ? const StatusColors(Color(0xFF0F3D1E), Color(0xFFBFF0CC))
            : const StatusColors(Color(0xFFD9F5E1), Color(0xFF145C2C)),
      StatusTone.red =>
        dark
            ? const StatusColors(Color(0xFF5A1616), Color(0xFFFFD3D0))
            : const StatusColors(Color(0xFFFFE1DE), Color(0xFF8C1D18)),
      StatusTone.teal =>
        dark
            ? const StatusColors(Color(0xFF07403F), Color(0xFFBDEFEC))
            : const StatusColors(Color(0xFFD5F3F1), Color(0xFF0B5753)),
      StatusTone.neutral =>
        dark
            ? const StatusColors(Color(0xFF3A3A3F), Color(0xFFE6E6EA))
            : const StatusColors(Color(0xFFE9E9EE), Color(0xFF3A3A40)),
    };
  }

  final Color background;
  final Color foreground;
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final info = OrderStatuses.info(status);
    final colors = StatusColors.of(info.tone, Theme.of(context).brightness);
    return Semantics(
      label: 'สถานะ: ${info.label}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(999),
          border: info.known ? null : Border.all(color: colors.foreground),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(info.icon, size: 16, color: colors.foreground),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  info.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
