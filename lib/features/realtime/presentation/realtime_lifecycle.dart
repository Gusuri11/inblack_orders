import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/features/realtime/application/realtime_providers.dart';

class RealtimeLifecycle extends ConsumerStatefulWidget {
  const RealtimeLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<RealtimeLifecycle> createState() => _RealtimeLifecycleState();
}

class _RealtimeLifecycleState extends ConsumerState<RealtimeLifecycle> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: (state) {
        final foreground =
            state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive;
        ref.read(realtimeControlProvider).setForeground(foreground: foreground);
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
