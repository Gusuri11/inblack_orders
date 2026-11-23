import 'dart:math';

import 'package:inblack_orders/core/network/api_exception.dart';

Future<void> _sleep(Duration d) => Future<void>.delayed(d);

class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 4,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
    this.sleep = _sleep,
  });

  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;
  final Future<void> Function(Duration) sleep;

  Duration delayFor(int attempt, ApiException error, [Random? random]) {
    final retryAfter = error.retryAfter;
    if (retryAfter != null) return retryAfter;
    final exp = baseDelay * pow(2, attempt - 1).toInt();
    final capped = exp > maxDelay ? maxDelay : exp;
    final half = capped.inMilliseconds ~/ 2;
    final jitter = (random ?? Random()).nextInt(half + 1);
    return Duration(milliseconds: half + jitter);
  }

  Future<T> run<T>(Future<T> Function() action) async {
    for (var attempt = 1; ; attempt++) {
      try {
        return await action();
      } on ApiException catch (e) {
        if (!e.isRetryable || attempt >= maxAttempts) rethrow;
        await sleep(delayFor(attempt, e));
      }
    }
  }
}
