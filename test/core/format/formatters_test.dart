import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/format/formatters.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('th');
    await initializeDateFormatting('en');
  });

  group('money', () {
    test('formats satang as baht with two decimals', () {
      expect(Formatters.money(17900), '฿179.00');
      expect(Formatters.money(123456), '฿1,234.56');
      expect(Formatters.money(5), '฿0.05');
      expect(Formatters.money(0), '฿0.00');
    });

    test('groups large values without floating point drift', () {
      expect(Formatters.money(999999999999), '฿9,999,999,999.99');
      expect(Formatters.money(1000000001), '฿10,000,000.01');
    });

    test('negative values keep the sign in front', () {
      expect(Formatters.money(-1050), '-฿10.50');
    });

    test('other currencies use the code', () {
      expect(Formatters.money(250, currency: 'USD'), 'USD 2.50');
    });
  });

  group('orderTime', () {
    final now = DateTime.utc(2026, 11, 6, 12);

    test('relative within 24 hours', () {
      expect(
        Formatters.orderTime(
          now.subtract(const Duration(seconds: 20)),
          now: now,
        ),
        'เมื่อสักครู่',
      );
      expect(
        Formatters.orderTime(
          now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
        '5 นาทีที่แล้ว',
      );
      expect(
        Formatters.orderTime(
          now.subtract(const Duration(hours: 23, minutes: 59)),
          now: now,
        ),
        '23 ชั่วโมงที่แล้ว',
      );
      expect(
        Formatters.orderTime(
          now.subtract(const Duration(minutes: 5)),
          now: now,
          locale: 'en',
        ),
        '5 min ago',
      );
    });

    test('a timestamp slightly in the future is "just now"', () {
      expect(
        Formatters.orderTime(now.add(const Duration(seconds: 30)), now: now),
        'เมื่อสักครู่',
      );
    });

    test('older than 24 hours shows the date in Asia/Bangkok', () {
      final t = DateTime.utc(2026, 11, 4, 20, 15);
      expect(
        Formatters.orderTime(t, now: now, locale: 'en'),
        '5 Nov 2026 03:15',
      );
    });

    test('Z and +07:00 inputs of the same instant render identically', () {
      final z = DateTime.parse('2026-11-01T03:12:44.120Z');
      final plus7 = DateTime.parse('2026-11-01T10:12:44.120+07:00');
      expect(Formatters.dateTime(z), Formatters.dateTime(plus7));
      expect(Formatters.dateTime(z, locale: 'en'), '1 Nov 2026 10:12');
    });
  });
}
