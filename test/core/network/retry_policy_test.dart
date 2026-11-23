import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/core/network/retry_policy.dart';

void main() {
  final sleeps = <Duration>[];
  late RetryPolicy policy;

  setUp(() {
    sleeps.clear();
    policy = RetryPolicy(maxAttempts: 3, sleep: (d) async => sleeps.add(d));
  });

  test('retries 5xx until it succeeds', () async {
    var calls = 0;
    final result = await policy.run(() async {
      calls++;
      if (calls < 3) throw const ApiException(statusCode: 503);
      return 'ok';
    });
    expect(result, 'ok');
    expect(calls, 3);
    expect(sleeps, hasLength(2));
  });

  test('gives up after maxAttempts', () async {
    var calls = 0;
    await expectLater(
      policy.run<void>(() async {
        calls++;
        throw const ApiException(isNetworkError: true);
      }),
      throwsA(isA<ApiException>()),
    );
    expect(calls, 3);
  });

  test('does not retry 4xx', () async {
    var calls = 0;
    await expectLater(
      policy.run<void>(() async {
        calls++;
        throw const ApiException(statusCode: 422, code: 'not_cancellable');
      }),
      throwsA(isA<ApiException>()),
    );
    expect(calls, 1);
    expect(sleeps, isEmpty);
  });

  test('honours Retry-After', () async {
    var calls = 0;
    await policy.run(() async {
      if (calls++ == 0) {
        throw const ApiException(
          statusCode: 429,
          retryAfter: Duration(seconds: 7),
        );
      }
    });
    expect(sleeps, [const Duration(seconds: 7)]);
  });

  test('backoff grows exponentially with jitter and is capped', () {
    const p = RetryPolicy(baseDelay: Duration(seconds: 1));
    const error = ApiException(statusCode: 500);
    final random = Random(1);
    for (final (attempt, full) in [
      (1, 1000),
      (2, 2000),
      (3, 4000),
      (6, 30000),
      (10, 30000),
    ]) {
      final d = p.delayFor(attempt, error, random).inMilliseconds;
      expect(d, inInclusiveRange(full ~/ 2, full), reason: 'attempt $attempt');
    }
  });
}
