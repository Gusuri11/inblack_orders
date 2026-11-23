import 'package:flutter/material.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({
    required this.selected,
    required this.summary,
    required this.onToggle,
    required this.onClear,
    super.key,
  });

  final Set<String> selected;
  final OrdersSummary? summary;
  final ValueChanged<String> onToggle;
  final VoidCallback onClear;

  List<String> get _statuses {
    final extra = {
      ...?summary?.counts.keys,
      ...selected,
    }.where((s) => !OrderStatuses.known.contains(s)).toList()..sort();
    return [...OrderStatuses.known, ...extra];
  }

  String _withCount(String label, int? count) =>
      count == null ? label : '$label ($count)';

  @override
  Widget build(BuildContext context) {
    final counts = summary?.counts;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_withCount('ทั้งหมด', summary?.total)),
              selected: selected.isEmpty,
              onSelected: (_) => onClear(),
            ),
          ),
          for (final status in _statuses)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(OrderStatuses.info(status).icon, size: 18),
                label: Text(
                  _withCount(
                    OrderStatuses.info(status).label,
                    counts == null ? null : (counts[status] ?? 0),
                  ),
                ),
                selected: selected.contains(status),
                onSelected: (_) => onToggle(status),
              ),
            ),
        ],
      ),
    );
  }
}
