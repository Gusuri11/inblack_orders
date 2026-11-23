import 'package:intl/intl.dart';

abstract final class Formatters {
  static const bangkokOffset = Duration(hours: 7);

  static String money(
    int minor, {
    String currency = 'THB',
    String locale = 'th',
  }) {
    final abs = minor.abs();
    final whole = NumberFormat.decimalPattern(locale).format(abs ~/ 100);
    final fraction = (abs % 100).toString().padLeft(2, '0');
    final symbol = currency == 'THB' ? '฿' : '$currency ';
    final sign = minor < 0 ? '-' : '';
    return '$sign$symbol$whole.$fraction';
  }

  static DateTime toBangkokWallClock(DateTime time) =>
      time.toUtc().add(bangkokOffset);

  static String dateTime(DateTime time, {String locale = 'th'}) =>
      DateFormat('d MMM yyyy HH:mm', locale).format(toBangkokWallClock(time));

  static String orderTime(
    DateTime time, {
    required DateTime now,
    String locale = 'th',
  }) {
    final diff = now.toUtc().difference(time.toUtc());
    final th = locale.startsWith('th');
    if (diff < const Duration(minutes: 1)) {
      return th ? 'เมื่อสักครู่' : 'just now';
    }
    if (diff < const Duration(hours: 1)) {
      final m = diff.inMinutes;
      return th ? '$m นาทีที่แล้ว' : '$m min ago';
    }
    if (diff < const Duration(hours: 24)) {
      final h = diff.inHours;
      return th ? '$h ชั่วโมงที่แล้ว' : '$h h ago';
    }
    return dateTime(time, locale: locale);
  }
}
