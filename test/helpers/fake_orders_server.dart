import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'fake_http_adapter.dart';

class FakeOrder {
  FakeOrder(this.id, this.createdAt, {this.status = 'PAID', this.version = 1});

  final String id;
  final DateTime createdAt;
  String status;
  int version;
  int changeSeq = 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'version': version,
    'totalMinor': 17900,
    'currency': 'THB',
    'lineCount': 1,
    'itemCount': 1,
    'primaryItem': {'sku': 'DM-0520', 'name': 'Diamond 💎', 'imageUrl': null},
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': createdAt.toIso8601String(),
  };
}

class FakeOrdersServer {
  FakeOrdersServer({int count = 0}) {
    final base = DateTime.utc(2026, 11);
    for (var i = 0; i < count; i++) {
      final o = FakeOrder('ORD-${100000 + i}', base.add(Duration(minutes: i)));
      orders.add(o);
    }
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  final List<FakeOrder> orders = [];
  final List<({int seq, String id})> tombstones = [];
  int seq = 0;
  int retainFrom = 0;
  final List<FakeResponse> failNext = [];
  final List<Object?> extraChanges = [];

  FakeOrder byId(String id) => orders.firstWhere((o) => o.id == id);

  void update(String id, String status) {
    byId(id)
      ..status = status
      ..version += 1
      ..changeSeq = ++seq;
  }

  void create(String id, DateTime createdAt) {
    final o = FakeOrder(id, createdAt)..changeSeq = ++seq;
    orders
      ..add(o)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void remove(String id) {
    orders.removeWhere((o) => o.id == id);
    tombstones.add((seq: ++seq, id: id));
  }

  void truncate() => retainFrom = seq;

  void reset() {
    seq = 0;
    retainFrom = 0;
    tombstones.clear();
    for (final o in orders) {
      o.changeSeq = 0;
    }
  }

  FutureOr<FakeResponse> handle(RequestOptions r) {
    if (failNext.isNotEmpty) return failNext.removeAt(0);
    final q = r.queryParameters;
    switch (r.path) {
      case '/orders':
        final limit = q['limit'] as int? ?? 20;
        final cursor = q['cursor'] as String?;
        var start = 0;
        if (cursor != null) {
          final lastId = utf8.decode(base64Url.decode(cursor));
          start = orders.indexWhere((o) => o.id == lastId) + 1;
        }
        final page = orders.skip(start).take(limit).toList();
        final more = start + page.length < orders.length;
        return FakeResponse(200, {
          'items': [for (final o in page) o.toJson()],
          'nextCursor': more
              ? base64Url.encode(utf8.encode(page.last.id))
              : null,
          'syncSeq': seq,
        });
      case '/orders/changes':
        final since = q['since'] as int;
        final limit = q['limit'] as int? ?? 100;
        if (since < retainFrom || since > seq) {
          return FakeResponse(410, {
            'error': 'resync_required',
            'syncSeq': seq,
          });
        }
        final all = <Map<String, dynamic>>[
          for (final o in orders)
            if (o.changeSeq > since)
              {'seq': o.changeSeq, 'type': 'upsert', 'order': o.toJson()},
          for (final t in tombstones)
            if (t.seq > since) {'seq': t.seq, 'type': 'delete', 'id': t.id},
        ]..sort((a, b) => (a['seq'] as int).compareTo(b['seq'] as int));
        final page = all.take(limit).toList();
        return FakeResponse(200, {
          'changes': [...page, ...extraChanges],
          'nextSince': page.isEmpty ? since : page.last['seq'],
          'hasMore': all.length > limit,
          'syncSeq': seq,
        });
    }
    return const FakeResponse(404, {'error': 'not_found'});
  }
}
