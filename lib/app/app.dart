import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/app/app_services.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/app/router.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/app_lock/app_lock.dart';
import 'package:inblack_orders/features/realtime/presentation/realtime_lifecycle.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

class InBlackOrdersApp extends ConsumerWidget {
  const InBlackOrdersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => DeepLinkListener(
        child: SessionServices(
          child: AppLockGate(
            onSignOut: () => ref.read(logoutProvider).logout(),
            child: RealtimeLifecycle(child: child ?? const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}
