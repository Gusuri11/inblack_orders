import 'dart:async';

import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/data/auth_api.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';

enum SessionEndReason {
  invalidGrant('invalid_grant'),
  tokenRevoked('token_revoked'),
  refreshTokenReused('refresh_token_reused'),
  unauthorized('unauthorized'),
  socketRevoked('ws_4003');

  SessionEndReason(this.code);

  final String code;

  static SessionEndReason fromCode(String? code) => values.firstWhere(
    (r) => r.code == code,
    orElse: () => SessionEndReason.unauthorized,
  );
}

class SessionManager {
  SessionManager({
    required this._api,
    required this._storage,
    this._maxRefreshAttempts = 3,
    this._retryDelay = const Duration(milliseconds: 500),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AuthApi _api;
  final TokenStorage _storage;
  final int _maxRefreshAttempts;
  final Duration _retryDelay;
  final DateTime Function() _clock;

  final _ended = StreamController<SessionEndReason>.broadcast();
  final _tokens = StreamController<String>.broadcast();

  StoredSession? _cache;
  bool _loaded = false;
  Future<String>? _inflight;
  DateTime? _accessExpiresAt;

  Stream<SessionEndReason> get sessionEnded => _ended.stream;

  Stream<String> get tokenChanges => _tokens.stream;

  DateTime? get accessExpiresAt => _accessExpiresAt;

  Future<StoredSession?> session() async {
    if (!_loaded) {
      _cache = await _storage.read();
      _loaded = true;
    }
    return _cache;
  }

  Future<void> start(StoredSession session, {Duration? expiresIn}) async {
    await _storage.save(session);
    final changed = _cache?.accessToken != session.accessToken;
    _cache = session;
    _loaded = true;
    _accessExpiresAt = expiresIn == null ? null : _clock().add(expiresIn);
    if (changed) _tokens.add(session.accessToken);
  }

  Future<String?> accessToken() async {
    final inflight = _inflight;
    if (inflight != null) {
      try {
        return await inflight;
      } on ApiException {
        return (await session())?.accessToken;
      }
    }
    return (await session())?.accessToken;
  }

  Future<String> refresh({required String failedAccessToken}) {
    return _inflight ??= _refresh(failedAccessToken).whenComplete(() {
      _inflight = null;
    });
  }

  Future<void> end(SessionEndReason reason) async {
    final hadSession = (await session()) != null;
    await clear();
    if (hadSession) _ended.add(reason);
  }

  Future<void> clear() async {
    await _storage.clear();
    _cache = null;
    _loaded = true;
    _accessExpiresAt = null;
  }

  Future<String> _refresh(String failedAccessToken) async {
    final current = await session();
    if (current == null) {
      throw ApiException(
        statusCode: 401,
        code: SessionEndReason.unauthorized.code,
      );
    }
    if (current.accessToken != failedAccessToken) return current.accessToken;

    for (var attempt = 1; ; attempt++) {
      try {
        final response = await _api.refresh(current.refreshToken);
        final next = StoredSession(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          userId: current.userId,
        );
        await start(next, expiresIn: Duration(seconds: response.expiresIn));
        return next.accessToken;
      } on ApiException catch (e) {
        if (e.statusCode == 401) {
          await end(SessionEndReason.fromCode(e.code));
          rethrow;
        }
        final retryable = e.isServerError || e.statusCode == 429;
        if (!retryable || attempt >= _maxRefreshAttempts) rethrow;
        await Future<void>.delayed(e.retryAfter ?? _retryDelay * attempt);
      }
    }
  }

  Future<void> dispose() async {
    await _ended.close();
    await _tokens.close();
  }
}
