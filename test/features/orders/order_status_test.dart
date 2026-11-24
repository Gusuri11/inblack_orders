import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/features/orders/domain/order_status.dart';
import 'package:inblack_orders/features/orders/presentation/widgets/status_badge.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

double _luminance(Color c) => c.computeLuminance();

double _contrast(Color a, Color b) {
  final l1 = _luminance(a);
  final l2 = _luminance(b);
  final hi = l1 > l2 ? l1 : l2;
  final lo = l1 > l2 ? l2 : l1;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  final th = lookupAppLocalizations(const Locale('th'));

  test('known statuses have Thai labels and distinct icons', () {
    final infos = OrderStatuses.known.map(OrderStatuses.info).toList();
    expect(infos.every((i) => i.known), isTrue);
    expect(infos.map((i) => i.icon).toSet(), hasLength(infos.length));
    expect(OrderStatuses.info('PAID').label(th), 'ชำระเงินแล้ว');
  });

  test('unknown status keeps the raw name', () {
    final info = OrderStatuses.info('ON_HOLD');
    expect(info.known, isFalse);
    expect(info.label(th), 'ON_HOLD');
    expect(info.tone, StatusTone.neutral);
  });

  test('every badge colour pair passes WCAG AA in light and dark', () {
    for (final tone in StatusTone.values) {
      for (final b in Brightness.values) {
        final c = StatusColors.of(tone, b);
        expect(
          _contrast(c.background, c.foreground),
          greaterThanOrEqualTo(4.5),
          reason: '$tone $b',
        );
      }
    }
  });

  testWidgets('badge exposes a readable semantics label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('th'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: StatusBadge(status: 'PAID')),
      ),
    );
    expect(find.bySemanticsLabel('สถานะ: ชำระเงินแล้ว'), findsOneWidget);
    expect(find.text('ชำระเงินแล้ว'), findsOneWidget);
    expect(find.byIcon(Icons.payments_outlined), findsOneWidget);
  });
}
