import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.languageCode = 'th',
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.notificationPromptShown = false,
    this.appLockEnabled = false,
    this.baseUrlOverride,
  });

  final String languageCode;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool notificationPromptShown;
  final bool appLockEnabled;
  final String? baseUrlOverride;

  Locale get locale => Locale(languageCode);

  AppSettings copyWith({
    String? languageCode,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? notificationPromptShown,
    bool? appLockEnabled,
    String? baseUrlOverride,
    bool clearBaseUrl = false,
  }) => AppSettings(
    languageCode: languageCode ?? this.languageCode,
    themeMode: themeMode ?? this.themeMode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    notificationPromptShown:
        notificationPromptShown ?? this.notificationPromptShown,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    baseUrlOverride: clearBaseUrl
        ? null
        : baseUrlOverride ?? this.baseUrlOverride,
  );
}

abstract final class _Keys {
  static const language = 'settings.language';
  static const theme = 'settings.theme';
  static const notifications = 'settings.notifications';
  static const prompt = 'settings.notification_prompt';
  static const appLock = 'settings.app_lock';
  static const baseUrl = 'settings.base_url';
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

AppSettings readSettings(SharedPreferences? prefs) {
  if (prefs == null) return const AppSettings();
  final language = prefs.getString(_Keys.language);
  final theme = prefs.getString(_Keys.theme);
  return AppSettings(
    languageCode: language == 'en' ? 'en' : 'th',
    themeMode: ThemeMode.values.firstWhere(
      (m) => m.name == theme,
      orElse: () => ThemeMode.system,
    ),
    notificationsEnabled: prefs.getBool(_Keys.notifications) ?? true,
    notificationPromptShown: prefs.getBool(_Keys.prompt) ?? false,
    appLockEnabled: prefs.getBool(_Keys.appLock) ?? false,
    baseUrlOverride: prefs.getString(_Keys.baseUrl),
  );
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<AppSettings> {
  SharedPreferences? get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() => readSettings(ref.watch(sharedPreferencesProvider));

  Future<void> setLanguage(String code) async {
    state = state.copyWith(languageCode: code);
    await _prefs?.setString(_Keys.language, code);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setString(_Keys.theme, mode.name);
  }

  Future<void> setNotifications({required bool enabled}) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _prefs?.setBool(_Keys.notifications, enabled);
  }

  Future<void> markNotificationPromptShown() async {
    state = state.copyWith(notificationPromptShown: true);
    await _prefs?.setBool(_Keys.prompt, true);
  }

  Future<void> setAppLock({required bool enabled}) async {
    state = state.copyWith(appLockEnabled: enabled);
    await _prefs?.setBool(_Keys.appLock, enabled);
  }

  Future<void> setBaseUrl(String? url) async {
    final value = url?.trim();
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearBaseUrl: true);
      await _prefs?.remove(_Keys.baseUrl);
    } else {
      state = state.copyWith(baseUrlOverride: value);
      await _prefs?.setString(_Keys.baseUrl, value);
    }
  }

  Future<void> resetForLogout() async {
    await _prefs?.remove(_Keys.prompt);
    await _prefs?.remove(_Keys.appLock);
    state = state.copyWith(
      notificationPromptShown: false,
      appLockEnabled: false,
    );
  }
}

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get languageCode => Localizations.localeOf(this).languageCode;
}
