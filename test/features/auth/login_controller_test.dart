import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/auth/application/login_controller.dart';
import 'package:inblack_orders/features/auth/application/login_state.dart';
import 'package:inblack_orders/features/auth/data/auth_models.dart';
import 'package:inblack_orders/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository;

const _user = AuthUser(id: 'u_alice', username: 'alice', displayName: 'Alice');

void main() {
  late _MockAuthRepository api;
  late ProviderContainer container;

  setUp(() {
    api = _MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);
    container.listen(loginControllerProvider, (_, _) {});
  });

  Future<void> submit(String u, String p) => container
      .read(loginControllerProvider.notifier)
      .submit(username: u, password: p);

  LoginState read() => container.read(loginControllerProvider);

  void stubLogin(Object error) {
    when(
      () => api.login(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenThrow(error);
  }

  test('empty fields are rejected without calling the API', () async {
    await submit('  ', '');
    expect(read().usernameError, FieldError.required);
    expect(read().passwordError, FieldError.required);
    verifyNever(
      () => api.login(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  test('successful login exposes the user', () async {
    when(() => api.login(username: 'alice', password: 'alice1234'))
        .thenAnswer((_) async => _user);

    await submit(' alice ', 'alice1234');

    expect(read().user?.username, 'alice');
    expect(read().isSubmitting, isFalse);
    expect(read().failure, isNull);
  });

  test('401 maps to invalidCredentials', () async {
    stubLogin(const ApiException(statusCode: 401, code: 'invalid_credentials'));
    await submit('alice', 'wrong');
    expect(read().failure, LoginFailure.invalidCredentials);
    expect(read().user, isNull);
  });

  test('network error maps to network failure', () async {
    stubLogin(const ApiException(isNetworkError: true));
    await submit('alice', 'x');
    expect(read().failure, LoginFailure.network);
  });

  test('5xx maps to server failure', () async {
    stubLogin(const ApiException(statusCode: 503));
    await submit('alice', 'x');
    expect(read().failure, LoginFailure.server);
  });

  test('429 locks out using retryAfterSec and counts down to zero', () {
    fakeAsync((async) {
      stubLogin(
        const ApiException(
          statusCode: 429,
          code: 'too_many_attempts',
          body: {'retryAfterSec': 3},
        ),
      );

      unawaited(submit('alice', 'x'));
      async.flushMicrotasks();

      expect(read().failure, LoginFailure.rateLimited);
      expect(read().retryAfterSeconds, 3);
      expect(read().canSubmit, isFalse);

      async.elapse(const Duration(seconds: 1));
      expect(read().retryAfterSeconds, 2);

      async.elapse(const Duration(seconds: 2));
      expect(read().retryAfterSeconds, 0);
      expect(read().canSubmit, isTrue);
      expect(read().failure, isNull);
    });
  });

  test('429 falls back to the Retry-After header', () async {
    stubLogin(
      const ApiException(statusCode: 429, retryAfter: Duration(seconds: 7)),
    );
    await submit('alice', 'x');
    expect(read().retryAfterSeconds, 7);
  });
}
