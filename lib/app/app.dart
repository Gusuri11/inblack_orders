import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/app/router.dart';
import 'package:inblack_orders/features/realtime/presentation/realtime_lifecycle.dart';

class InBlackOrdersApp extends ConsumerWidget {
  const InBlackOrdersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'InBlack Orders',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) =>
          RealtimeLifecycle(child: child ?? const SizedBox.shrink()),
    );
  }
}
