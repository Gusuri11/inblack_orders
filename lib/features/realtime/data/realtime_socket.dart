import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract interface class RealtimeSocket {
  Future<void> get ready;
  Stream<dynamic> get messages;
  int? get closeCode;
  void send(String text);
  Future<void> close([int? code]);
}

typedef SocketConnector = RealtimeSocket Function(Uri uri);

class ChannelSocket implements RealtimeSocket {
  ChannelSocket(Uri uri) : _channel = WebSocketChannel.connect(uri);

  final WebSocketChannel _channel;

  @override
  Future<void> get ready => _channel.ready;

  @override
  Stream<dynamic> get messages => _channel.stream;

  @override
  int? get closeCode => _channel.closeCode;

  @override
  void send(String text) => _channel.sink.add(text);

  @override
  Future<void> close([int? code]) async {
    await _channel.sink.close(code);
  }
}
