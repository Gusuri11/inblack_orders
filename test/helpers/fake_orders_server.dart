import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'fake_http_adapter.dart';

class FakeOrder {
  FakeOrder(
    this.id,
    this.createdAt, {
    this.status = 'PAID',
    this.version = 1,
    this.name = 'Diamond 💎',
    this.playerId = '51234567',
  });

  final String id;
  final DateTime createdAt;
  String status;
  int version;
  String name;
  String playerId;
  int changeSeq = 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'version': version,
    'totalMinor': 17900,
    'currency': 'THB',
    'lineCount': 1,
    'itemCount': 1,
    'primaryItem': {'sku': 'DM-0520', 'name': name, 'imageUrl': null},
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': createdAt.toIso8601String(),
  };

  final List<String> notes = [];

  String get etag => '"v$version-n${notes.length}"';

  Map<String, dynamic> toDetailJson() => {
    ...toJson(),
    'playerId': playerId,
    'channel': 'APP',
    'items': [
      {
        'sku': 'DM-0520',
        'name': name,
        'quantity': 1,
        'unitPriceMinor': 17900,
        'imageUrl': null,
      },
    ],
    'history': [
      {
        'status': status,
        'at': createdAt.toIso8601String(),
        'by': 'system',
        'note': null,
      },
    ],
    'notes': [
      for (final (i, n) in notes.indexed)
        {
          'id': 'n_$i',
          'text': n,
          'author': 'customer',
          'createdAt': createdAt.toIso8601String(),
        },
    ],
    'attachments': <Object>[],
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
  final Map<String, ({String fp, FakeResponse response})> idem = {};
  final List<String> seenKeys = [];
  int loseResponses = 0;
  int cancelsApplied = 0;
  int notesCreated = 0;

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

  Duration? Function(RequestOptions r)? delay;
  FakeResponse? Function(RequestOptions r)? intercept;

  Future<FakeResponse> handle(RequestOptions r) async {
    final d = delay?.call(r);
    if (d != null) await Future<void>.delayed(d);
    final custom = intercept?.call(r);
    if (custom != null) return custom;
    return _handle(r);
  }

  FakeResponse _mutate(RequestOptions r, String id, String action) {
    final key = r.headers['Idempotency-Key'] as String?;
    if (key == null || key.length < 8) {
      return const FakeResponse(400, {'error': 'idempotency_key_required'});
    }
    seenKeys.add(key);
    final body = (r.data as Map<String, dynamic>?) ?? const {};
    final ifMatch = r.headers['If-Match'];
    final fp = '$action:$id:$ifMatch:${body['reason'] ?? body['text']}';
    final prev = idem[key];
    if (prev != null) {
      if (prev.fp != fp) {
        return const FakeResponse(422, {'error': 'idempotency_key_reused'});
      }
      return prev.response;
    }
    final o = orders.where((x) => x.id == id).firstOrNull;
    final FakeResponse response;
    if (o == null) {
      response = const FakeResponse(404, {'error': 'order_not_found'});
    } else if (action == 'notes') {
      o.notes.add('${body['text']}');
      notesCreated++;
      response = FakeResponse(201, {
        'id': 'n_${o.notes.length - 1}',
        'text': body['text'],
        'author': 'customer',
        'createdAt': o.createdAt.toIso8601String(),
      });
    } else if ('$ifMatch' != '${o.version}') {
      response = FakeResponse(409, {
        'error': 'version_conflict',
        'current': o.toDetailJson(),
      });
    } else if (o.status != 'PENDING' && o.status != 'PAID') {
      response = FakeResponse(422, {
        'error': 'not_cancellable',
        'current': o.toDetailJson(),
      });
    } else {
      update(id, 'CANCELLED');
      cancelsApplied++;
      response = FakeResponse(200, o.toDetailJson());
    }
    idem[key] = (fp: fp, response: response);
    if (loseResponses > 0 && response.status < 300) {
      loseResponses--;
      throwNetworkError();
    }
    return response;
  }

  FakeResponse _handle(RequestOptions r) {
    if (failNext.isNotEmpty) return failNext.removeAt(0);
    final q = r.queryParameters;
    switch (r.path) {
      case '/orders':
        final limit = q['limit'] as int? ?? 20;
        final cursor = q['cursor'] as String?;
        final statuses = ((q['status'] as String?) ?? '')
            .split(',')
            .where((s) => s.isNotEmpty)
            .toSet();
        final text = ((q['q'] as String?) ?? '').toLowerCase();
        final filterKey = '${(statuses.toList()..sort()).join(',')}|$text';
        final matching = orders
            .where(
              (o) =>
                  (statuses.isEmpty || statuses.contains(o.status)) &&
                  (text.isEmpty ||
                      o.id.toLowerCase().contains(text) ||
                      o.name.toLowerCase().contains(text) ||
                      o.playerId.contains(text)),
            )
            .toList();
        var start = 0;
        if (cursor != null) {
          final decoded = utf8.decode(base64Url.decode(cursor)).split('#');
          if (decoded.length != 2 || decoded[1] != filterKey) {
            return const FakeResponse(400, {'error': 'invalid_cursor'});
          }
          start = matching.indexWhere((o) => o.id == decoded[0]) + 1;
        }
        final page = matching.skip(start).take(limit).toList();
        final more = start + page.length < matching.length;
        return FakeResponse(200, {
          'items': [for (final o in page) o.toJson()],
          'nextCursor': more
              ? base64Url.encode(utf8.encode('${page.last.id}#$filterKey'))
              : null,
          'syncSeq': seq,
        });
      case '/orders/summary':
        final counts = <String, int>{};
        for (final o in orders) {
          counts[o.status] = (counts[o.status] ?? 0) + 1;
        }
        return FakeResponse(200, {
          'counts': counts,
          'total': orders.length,
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
    final mutation = RegExp(r'^/orders/([^/]+)/(cancel|notes)$').firstMatch(r.path);
    if (mutation != null && r.method == 'POST') {
      return _mutate(r, Uri.decodeComponent(mutation.group(1) ?? ''), mutation.group(2) ?? '');
    }
    final detailMatch = RegExp(r'^/orders/([^/]+)$').firstMatch(r.path);
    if (detailMatch != null) {
      final id = Uri.decodeComponent(detailMatch.group(1) ?? '');
      final o = orders.where((x) => x.id == id).firstOrNull;
      if (o == null) {
        return const FakeResponse(404, {'error': 'order_not_found'});
      }
      if (r.headers['If-None-Match'] == o.etag) {
        return FakeResponse(304, null, {'etag': o.etag});
      }
      return FakeResponse(200, o.toDetailJson(), {'etag': o.etag});
    }
    return const FakeResponse(404, {'error': 'not_found'});
  }
}
