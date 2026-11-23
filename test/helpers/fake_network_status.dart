import 'dart:async';

import 'package:inblack_orders/core/connectivity/network_status.dart';

class FakeNetworkStatus implements NetworkStatus {
  FakeNetworkStatus({this.online = true});

  bool online;
  final _changes = StreamController<bool>.broadcast();

  void set({required bool online}) {
    this.online = online;
    _changes.add(online);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> get changes => _changes.stream;
}
