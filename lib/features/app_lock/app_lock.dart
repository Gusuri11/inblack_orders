import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:local_auth/local_auth.dart';

abstract interface class DeviceAuth {
  Future<bool> isSupported();
  Future<bool> authenticate(String reason);
}

class LocalDeviceAuth implements DeviceAuth {
  LocalDeviceAuth([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on Object {
      return false;
    }
  }
}

final deviceAuthProvider = Provider<DeviceAuth>((ref) => LocalDeviceAuth());

class AppLockState {
  const AppLockState({
    this.locked = false,
    this.obscured = false,
    this.cannotVerify = false,
  });

  final bool locked;
  final bool obscured;
  final bool cannotVerify;

  AppLockState copyWith({bool? locked, bool? obscured, bool? cannotVerify}) =>
      AppLockState(
        locked: locked ?? this.locked,
        obscured: obscured ?? this.obscured,
        cannotVerify: cannotVerify ?? this.cannotVerify,
      );
}

final appLockProvider = NotifierProvider<AppLockController, AppLockState>(
  AppLockController.new,
);

class AppLockController extends Notifier<AppLockState> {
  static const grace = Duration(seconds: 30);

  DateTime? _backgroundAt;
  DateTime Function() clock = DateTime.now;

  bool get _enabled => ref.read(settingsProvider).appLockEnabled;

  @override
  AppLockState build() => AppLockState(locked: _enabled);

  void onLifecycle(AppLifecycleState lifecycle) {
    switch (lifecycle) {
      case AppLifecycleState.inactive:
        state = state.copyWith(obscured: true);
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _backgroundAt ??= clock();
        state = state.copyWith(obscured: true);
      case AppLifecycleState.resumed:
        final since = _backgroundAt;
        _backgroundAt = null;
        final expired = since != null && clock().difference(since) > grace;
        state = state.copyWith(
          obscured: false,
          locked: state.locked || (_enabled && expired),
        );
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<bool> unlock(String reason) async {
    final auth = ref.read(deviceAuthProvider);
    if (!await auth.isSupported()) {
      state = state.copyWith(cannotVerify: true);
      return false;
    }
    final ok = await auth.authenticate(reason);
    if (ok) state = const AppLockState();
    return ok;
  }

  Future<bool> enable(String reason) async {
    final auth = ref.read(deviceAuthProvider);
    if (!await auth.isSupported()) return false;
    if (!await auth.authenticate(reason)) return false;
    await ref.read(settingsProvider.notifier).setAppLock(enabled: true);
    return true;
  }

  Future<void> disable() async {
    await ref.read(settingsProvider.notifier).setAppLock(enabled: false);
    state = const AppLockState();
  }

  void reset() => state = const AppLockState();
}

class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, required this.onSignOut, super.key});

  final Widget child;
  final Future<void> Function() onSignOut;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: (s) => ref.read(appLockProvider.notifier).onLifecycle(s),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (lock.locked)
          _LockScreen(state: lock, onSignOut: widget.onSignOut)
        else if (lock.obscured)
          const _PrivacyCover(),
      ],
    );
  }
}

class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Icon(
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _LockScreen extends ConsumerWidget {
  const _LockScreen({required this.state, required this.onSignOut});

  final AppLockState state;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Positioned.fill(
      child: Material(
        color: scheme.surface,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 56, color: scheme.primary),
                  const SizedBox(height: 16),
                  Semantics(
                    header: true,
                    child: Text(
                      l.locked,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (state.cannotVerify) ...[
                    const SizedBox(height: 12),
                    Text(l.appLockUnavailable, textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(200, 48),
                    ),
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l.unlock),
                    onPressed: () => unawaited(
                      ref
                          .read(appLockProvider.notifier)
                          .unlock(l.appLockReason),
                    ),
                  ),
                  if (state.cannotVerify) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        await onSignOut();
                        ref.read(appLockProvider.notifier).reset();
                      },
                      child: Text(l.logout),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
