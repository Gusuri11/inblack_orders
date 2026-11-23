import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:inblack_orders/core/connectivity/network_status.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/auth/data/session_manager.dart';
import 'package:inblack_orders/features/realtime/data/order_event_applier.dart';
import 'package:inblack_orders/features/realtime/data/realtime_event.dart';
import 'package:inblack_orders/features/realtime/data/realtime_socket.dart';

enum ConnectionStatus { live, reconnecting, offline }

class RealtimeClient {
  RealtimeClient({
    required Uri baseUrl,
    required this._session,
    required this._sink,
    required this._connector,
    required this._network,
    required this._verifySession,
    Random? random,
    DateTime Function()? clock,
    this._renewBefore = const Duration(seconds: 10),
  }) : _wsBase = baseUrl.replace(
         scheme: baseUrl.scheme == 'https' ? 'wss' : 'ws',
         path: '/ws',
       ),
       _random = random ?? Random(),
       _clock = clock ?? DateTime.now;

  static const minBackoff = Duration(seconds: 1);
  static const maxBackoff = Duration(seconds: 30);

  final Uri _wsBase;
  final SessionManager _session;
  final OrderEventSink _sink;
  final SocketConnector _connector;
  final NetworkStatus _network;
  final Future<void> Function() _verifySession;
  final Random _random;
  final DateTime Function() _clock;
  final Duration _renewBefore;

  final _status = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _current = ConnectionStatus.offline;

  bool _enabled = false;
  bool _foreground = true;
  bool _online = true;
  bool _started = false;

  RealtimeSocket? _socket;
  StreamSubscription<dynamic>? _messages;
  StreamSubscription<bool>? _networkSub;
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<SessionEndReason>? _endSub;
  Timer? _reconnectTimer;
  Timer? _watchdog;
  Timer? _pingTimer;
  Timer? _renewTimer;

  int _connection = 0;
  int _attempt = 0;
  String? _token;
  Duration _heartbeat = const Duration(seconds: 15);
  DateTime _lastMessage = DateTime.fromMillisecondsSinceEpoch(0);

  Stream<ConnectionStatus> get status => _status.stream;

  ConnectionStatus get current => _current;

  int get attempt => _attempt;

  static Duration backoffFor(int attempt, Random random) {
    final exp = minBackoff * pow(2, max(0, attempt - 1)).toInt();
    final capped = exp > maxBackoff ? maxBackoff : exp;
    final ms = capped.inMilliseconds;
    return Duration(milliseconds: ms ~/ 2 + random.nextInt(ms ~/ 2 + 1));
  }

  Future<void> setEnabled({required bool enabled}) async {
    await _ensureStarted();
    _enabled = enabled;
    _evaluate();
  }

  void setForeground({required bool foreground}) {
    _foreground = foreground;
    _evaluate();
  }

  Future<void> _ensureStarted() async {
    if (_started) return;
    _started = true;
    _online = await _network.isOnline();
    _networkSub = _network.changes.listen((online) {
      final cameBack = online && !_online;
      _online = online;
      if (cameBack) {
        _attempt = 0;
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
      _evaluate();
    });
    _tokenSub = _session.tokenChanges.listen(_onTokenChanged);
    _endSub = _session.sessionEnded.listen((_) {
      _enabled = false;
      _evaluate();
    });
  }

  bool get _shouldRun => _enabled && _foreground && _online;

  void _evaluate() {
    if (!_shouldRun) {
      _connection++;
      _teardown();
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _setStatus(ConnectionStatus.offline);
      return;
    }
    if (_socket == null && _reconnectTimer == null) unawaited(_connect());
  }

  Future<void> _connect() async {
    final id = ++_connection;
    if (_current != ConnectionStatus.live) {
      _setStatus(ConnectionStatus.reconnecting);
    }
    final token = await _session.accessToken();
    if (id != _connection || !_shouldRun) return;
    if (token == null) {
      _enabled = false;
      _setStatus(ConnectionStatus.offline);
      return;
    }

    final socket = _connector(
      _wsBase.replace(queryParameters: {'access_token': token}),
    );
    _socket = socket;
    try {
      await socket.ready;
    } on Object {
      if (id != _connection) return;
      _socket = null;
      await _onHandshakeFailed(token);
      return;
    }
    if (id != _connection || !_shouldRun) {
      unawaited(socket.close());
      return;
    }

    _token = token;
    _lastMessage = _clock();
    _messages = socket.messages.listen(
      _onMessage,
      onDone: () => _onClosed(id, socket.closeCode),
      onError: (Object _) => _onClosed(id, null),
      cancelOnError: true,
    );
    _startTimers();
    _scheduleRenewal();
  }

  Future<void> _onHandshakeFailed(String token) async {
    try {
      await _verifySession();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        _enabled = false;
        _evaluate();
        return;
      }
    }
    final fresh = await _session.accessToken();
    if (fresh != null && fresh != token && _shouldRun) {
      unawaited(_connect());
      return;
    }
    _scheduleReconnect();
  }

  void _onMessage(dynamic raw) {
    _lastMessage = _clock();
    if (raw is! String) return;
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return;
    }
    if (decoded is! Map<String, dynamic>) return;
    final event = RealtimeEvent.parse(decoded);
    switch (event) {
      case Hello():
        _attempt = 0;
        _heartbeat = Duration(seconds: max(1, event.heartbeatSec));
        _startTimers();
        _setStatus(ConnectionStatus.live);
        unawaited(_sink.onHello(event));
      case OrderEvent():
        unawaited(_sink.onEvent(event));
      case KeepAlive():
      case null:
        break;
    }
  }

  void _onClosed(int id, int? code) {
    if (id != _connection) return;
    _teardown();
    switch (code) {
      case 4003:
        _enabled = false;
        unawaited(_session.end(SessionEndReason.socketRevoked));
        _setStatus(ConnectionStatus.offline);
      case 4001:
        unawaited(_refreshAndReconnect());
      default:
        _scheduleReconnect();
    }
  }

  Future<void> _refreshAndReconnect() async {
    final used = _token;
    try {
      if (used != null) await _session.refresh(failedAccessToken: used);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        _enabled = false;
        _evaluate();
        return;
      }
      _scheduleReconnect();
      return;
    }
    if (_shouldRun) unawaited(_connect());
  }

  void _scheduleReconnect() {
    if (!_shouldRun) {
      _evaluate();
      return;
    }
    _setStatus(ConnectionStatus.reconnecting);
    _attempt++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(backoffFor(_attempt, _random), () {
      _reconnectTimer = null;
      if (_shouldRun) unawaited(_connect());
    });
  }

  void _startTimers() {
    _watchdog?.cancel();
    _pingTimer?.cancel();
    final silenceLimit = _heartbeat * 2 + const Duration(seconds: 5);
    _watchdog = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_clock().difference(_lastMessage) > silenceLimit) _onStalled();
    });
    _pingTimer = Timer.periodic(_heartbeat, (_) {
      _socket?.send(jsonEncode({'type': 'ping'}));
    });
  }

  void _onStalled() {
    _connection++;
    _teardown();
    _scheduleReconnect();
  }

  void _scheduleRenewal() {
    _renewTimer?.cancel();
    final expiresAt = _session.accessExpiresAt;
    if (expiresAt == null) return;
    var wait = expiresAt.difference(_clock()) - _renewBefore;
    if (wait.isNegative) wait = Duration.zero;
    _renewTimer = Timer(wait, () => unawaited(_renewToken()));
  }

  Future<void> _renewToken() async {
    final used = _token;
    if (used == null || _socket == null) return;
    try {
      final fresh = await _session.refresh(failedAccessToken: used);
      if (fresh != _token) _sendAuth(fresh);
    } on ApiException {
      return;
    }
  }

  void _onTokenChanged(String token) {
    if (_socket == null || token == _token) return;
    _sendAuth(token);
  }

  void _sendAuth(String token) {
    final socket = _socket;
    if (socket == null) return;
    _token = token;
    socket.send(jsonEncode({'type': 'auth', 'accessToken': token}));
    _scheduleRenewal();
  }

  void _teardown() {
    _watchdog?.cancel();
    _pingTimer?.cancel();
    _renewTimer?.cancel();
    _watchdog = null;
    _pingTimer = null;
    _renewTimer = null;
    unawaited(_messages?.cancel());
    _messages = null;
    final socket = _socket;
    _socket = null;
    if (socket != null) unawaited(socket.close().catchError((Object _) {}));
  }

  void _setStatus(ConnectionStatus next) {
    if (_current == next) return;
    _current = next;
    if (!_status.isClosed) _status.add(next);
  }

  Future<void> dispose() async {
    _connection++;
    _enabled = false;
    _teardown();
    _reconnectTimer?.cancel();
    await _networkSub?.cancel();
    await _tokenSub?.cancel();
    await _endSub?.cancel();
    await _status.close();
  }
}
