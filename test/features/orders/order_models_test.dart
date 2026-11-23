import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';

void main() {
  test('OrderSummary parses Z and +07:00 timestamps to the same instant', () {
    final a = OrderSummary.fromJson({
      'id': 'ORD-1',
      'status': 'PAID',
      'version': 2,
      'totalMinor': 17900,
      'createdAt': '2026-11-06T03:12:44.120Z',
      'updatedAt': '2026-11-06T10:12:44.120+07:00',
    });
    expect(a.updatedAt.isAtSameMomentAs(a.createdAt), isTrue);
    expect(a.currency, 'THB');
  });

  test('unknown status and null primaryItem are accepted', () {
    final o = OrderSummary.fromJson({
      'id': 'ORD-2',
      'status': 'ON_HOLD',
      'version': 1,
      'totalMinor': 0,
      'primaryItem': null,
      'createdAt': '2026-11-06T03:12:44.120Z',
      'updatedAt': '2026-11-06T03:12:44.120Z',
    });
    expect(o.status, 'ON_HOLD');
    expect(o.primaryItem, isNull);
  });

  test('OrderDetail tolerates empty items and missing lists', () {
    final d = OrderDetail.fromJson({
      'id': 'ORD-3',
      'status': 'PENDING',
      'version': 1,
      'totalMinor': 100,
      'createdAt': '2026-11-06T03:12:44.120Z',
      'updatedAt': '2026-11-06T03:12:44.120Z',
      'items': <Object>[],
    });
    expect(d.items, isEmpty);
    expect(d.notes, isEmpty);
  });

  test('OrdersSummary keeps unknown status keys', () {
    final s = OrdersSummary.fromJson({
      'counts': {'PAID': 10, 'WEIRD': 1},
      'total': 11,
      'syncSeq': 5,
    });
    expect(s.counts['WEIRD'], 1);
  });
}
