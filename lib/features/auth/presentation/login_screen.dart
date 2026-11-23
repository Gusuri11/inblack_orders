import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/features/auth/application/auth_status.dart';
import 'package:inblack_orders/features/auth/application/login_controller.dart';
import 'package:inblack_orders/features/auth/application/login_state.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({this.from, super.key});

  final String? from;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(loginControllerProvider.notifier)
          .submit(username: _username.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider.select((s) => s.user), (_, user) {
      if (user != null) ref.read(authStatusProvider.notifier).signedIn();
    });
    final endReason = ref.watch(authStatusProvider).endReason;

    final state = ref.watch(loginControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        'InBlack Orders',
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เข้าสู่ระบบเพื่อติดตามคำสั่งซื้อ',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (endReason != null) ...[
                      const SizedBox(height: 16),
                      _SessionEndedNotice(
                        reason: endReason,
                        resumes: widget.from != null,
                      ),
                    ],
                    const SizedBox(height: 32),
                    TextField(
                      controller: _username,
                      enabled: !state.isSubmitting,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'ชื่อผู้ใช้',
                        border: const OutlineInputBorder(),
                        errorText: state.usernameError == null
                            ? null
                            : 'กรุณากรอกชื่อผู้ใช้',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _password,
                      enabled: !state.isSubmitting,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        border: const OutlineInputBorder(),
                        errorText: state.passwordError == null
                            ? null
                            : 'กรุณากรอกรหัสผ่าน',
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'แสดงรหัสผ่าน' : 'ซ่อนรหัสผ่าน',
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FailureMessage(state: state),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: state.canSubmit ? _submit : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              state.isLockedOut
                                  ? 'ลองใหม่ได้ใน ${state.retryAfterSeconds} วินาที'
                                  : 'เข้าสู่ระบบ',
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FailureMessage extends StatelessWidget {
  const _FailureMessage({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context) {
    final failure = state.failure;
    if (failure == null) return const SizedBox.shrink();

    final message = switch (failure) {
      LoginFailure.invalidCredentials => 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
      LoginFailure.rateLimited =>
        'ลองเข้าสู่ระบบผิดหลายครั้งเกินไป กรุณารอ '
            '${state.retryAfterSeconds} วินาที',
      LoginFailure.network =>
        'ไม่สามารถเชื่อมต่อได้ ตรวจสอบอินเทอร์เน็ตแล้วลองใหม่',
      LoginFailure.server => 'เซิร์ฟเวอร์ขัดข้องชั่วคราว กรุณาลองใหม่อีกครั้ง',
      LoginFailure.unknown => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
    };

    final color = Theme.of(context).colorScheme.error;
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}

class _SessionEndedNotice extends StatelessWidget {
  const _SessionEndedNotice({required this.reason, required this.resumes});

  final SessionEndReason reason;
  final bool resumes;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final message = switch (reason) {
      SessionEndReason.refreshTokenReused ||
      SessionEndReason.socketRevoked ||
      SessionEndReason.tokenRevoked =>
        'เพื่อความปลอดภัย เซสชันของคุณถูกยกเลิก กรุณาเข้าสู่ระบบอีกครั้ง',
      _ => 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบอีกครั้ง',
    };
    return Semantics(
      liveRegion: true,
      child: Card(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            resumes ? '$message แล้วเราจะพาคุณกลับไปหน้าเดิม' : message,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
      ),
    );
  }
}
