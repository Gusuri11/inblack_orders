import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';

enum AuthPhase { unknown, signedIn, signedOut }

class AuthStatus {
  const AuthStatus(this.phase, {this.endReason});

  final AuthPhase phase;
  final SessionEndReason? endReason;
}

final authStatusProvider = NotifierProvider<AuthStatusNotifier, AuthStatus>(
  AuthStatusNotifier.new,
);

class AuthStatusNotifier extends Notifier<AuthStatus> {
  StreamSubscription<SessionEndReason>? _ended;

  @override
  AuthStatus build() {
    final session = ref.watch(sessionManagerProvider);
    _ended = session.sessionEnded.listen((reason) {
      state = AuthStatus(AuthPhase.signedOut, endReason: reason);
    });
    ref.onDispose(() => unawaited(_ended?.cancel()));
    unawaited(_load(session));
    return const AuthStatus(AuthPhase.unknown);
  }

  Future<void> _load(SessionManager session) async {
    final current = await session.session();
    if (state.phase != AuthPhase.unknown) return;
    state = AuthStatus(
      current == null ? AuthPhase.signedOut : AuthPhase.signedIn,
    );
  }

  void signedIn() => state = const AuthStatus(AuthPhase.signedIn);

  void signedOut() => state = const AuthStatus(AuthPhase.signedOut);
}
