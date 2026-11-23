import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';

part 'login_state.freezed.dart';

enum FieldError { required }

enum LoginFailure { invalidCredentials, rateLimited, network, server, unknown }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isSubmitting,
    FieldError? usernameError,
    FieldError? passwordError,
    LoginFailure? failure,

    @Default(0) int retryAfterSeconds,

    AuthUser? user,
  }) = _LoginState;

  const LoginState._();

  bool get isLockedOut => retryAfterSeconds > 0;
  bool get canSubmit => !isSubmitting && !isLockedOut;
}
