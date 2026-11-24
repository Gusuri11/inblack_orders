import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/app/app_services.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/notifications/notification_providers.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/app_lock/app_lock.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _baseUrl = TextEditingController(
    text: ref.read(settingsProvider).baseUrlOverride ?? AppConfig.baseUrl,
  );
  bool _permissionDenied = false;
  bool _lockUnavailable = false;

  @override
  void dispose() {
    _baseUrl.dispose();
    super.dispose();
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _toggleNotifications(bool value) async {
    final notifier = ref.read(settingsProvider.notifier);
    if (!value) {
      await notifier.setNotifications(enabled: false);
      return;
    }
    final granted = await ref
        .read(notificationPresenterProvider)
        .requestPermission();
    await notifier.setNotifications(enabled: granted);
    await notifier.markNotificationPromptShown();
    if (mounted) setState(() => _permissionDenied = !granted);
  }

  Future<void> _toggleLock(bool value) async {
    final lock = ref.read(appLockProvider.notifier);
    if (!value) {
      await lock.disable();
      return;
    }
    final ok = await lock.enable(context.l10n.appLockEnableReason);
    if (mounted) setState(() => _lockUnavailable = !ok);
  }

  Future<void> _logout() async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.keepOrder),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.logout),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await ref.read(logoutProvider).logout();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider);
    final info = ref.watch(packageInfoProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _Header(l.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'th', label: Text(l.languageThai)),
                ButtonSegment(value: 'en', label: Text(l.languageEnglish)),
              ],
              selected: {settings.languageCode},
              onSelectionChanged: (v) => unawaited(
                ref.read(settingsProvider.notifier).setLanguage(v.first),
              ),
            ),
          ),
          _Header(l.theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l.themeLight),
                ),
                ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (v) => unawaited(
                ref.read(settingsProvider.notifier).setTheme(v.first),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l.notifications),
            subtitle: Text(
              _permissionDenied ? l.notificationsDenied : l.notificationsHint,
            ),
            value: settings.notificationsEnabled,
            onChanged: (v) => unawaited(_toggleNotifications(v)),
          ),
          SwitchListTile(
            title: Text(l.appLock),
            subtitle: Text(
              _lockUnavailable ? l.appLockUnavailable : l.appLockHint,
            ),
            value: settings.appLockEnabled,
            onChanged: (v) => unawaited(_toggleLock(v)),
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: Text(l.clearImageCache),
            onTap: () async {
              final done = l.imageCacheCleared;
              await clearImageCaches();
              if (mounted) _snack(done);
            },
          ),
          if (AppConfig.isDev) ...[
            _Header(l.baseUrl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _baseUrl,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        helperText: l.baseUrlHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(64, 48),
                    ),
                    onPressed: () => unawaited(
                      ref
                          .read(settingsProvider.notifier)
                          .setBaseUrl(_baseUrl.text),
                    ),
                    child: Text(l.save),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              l.version(info?.version ?? '-', info?.buildNumber ?? '-'),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l.logout,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => unawaited(_logout()),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

class NotificationPrompt extends ConsumerWidget {
  const NotificationPrompt({required this.supported, super.key});

  final bool supported;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    if (!supported || settings.notificationPromptShown) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final notifier = ref.read(settingsProvider.notifier);
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.enableNotificationsTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(l.enableNotificationsBody),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 4,
                children: [
                  TextButton(
                    onPressed: () =>
                        unawaited(notifier.markNotificationPromptShown()),
                    child: Text(l.notNow),
                  ),
                  FilledButton.tonal(
                    onPressed: () async {
                      final granted = await ref
                          .read(notificationPresenterProvider)
                          .requestPermission();
                      await notifier.setNotifications(enabled: granted);
                      await notifier.markNotificationPromptShown();
                    },
                    child: Text(l.enable),
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
