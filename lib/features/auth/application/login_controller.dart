import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/auth/application/login_state.dart';

final NotifierProvider<LoginController, LoginState> loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginState>(
      LoginController.new,
    );

class LoginController extends Notifier<LoginState> {
  Timer? _countdown;

  @override
  LoginState build() {
    ref.onDispose(() => _countdown?.cancel());
    return const LoginState();
  }

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    if (!state.canSubmit) return;

    final trimmedUser = username.trim();
    final userError = trimmedUser.isEmpty ? FieldError.required : null;
    final passError = password.isEmpty ? FieldError.required : null;
    if (userError != null || passError != null) {
      state = state.copyWith(
        usernameError: userError,
        passwordError: passError,
        failure: null,
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      usernameError: null,
      passwordError: null,
      failure: null,
    );

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(username: trimmedUser, password: password);
      state = state.copyWith(isSubmitting: false, user: user);
    } on ApiException catch (e) {
      _handleFailure(e);
    }
  }

  void _handleFailure(ApiException e) {
    if (e.statusCode == 429) {
      final seconds = _retryAfterSeconds(e);
      state = state.copyWith(
        isSubmitting: false,
        failure: LoginFailure.rateLimited,
        retryAfterSeconds: seconds,
      );
      _startCountdown();
      return;
    }

    final failure = switch (e) {
      ApiException(statusCode: 401) => LoginFailure.invalidCredentials,
      ApiException(isNetworkError: true) => LoginFailure.network,
      ApiException(isServerError: true) => LoginFailure.server,
      _ => LoginFailure.unknown,
    };
    state = state.copyWith(isSubmitting: false, failure: failure);
  }

  int _retryAfterSeconds(ApiException e) {
    final fromBody = e.body?['retryAfterSec'];
    if (fromBody is num && fromBody > 0) return fromBody.ceil();
    final fromHeader = e.retryAfter?.inSeconds;
    return (fromHeader != null && fromHeader > 0) ? fromHeader : 1;
  }

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.retryAfterSeconds - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(retryAfterSeconds: 0, failure: null);
      } else {
        state = state.copyWith(retryAfterSeconds: next);
      }
    });
  }
}
