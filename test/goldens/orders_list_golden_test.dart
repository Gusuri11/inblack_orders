import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/connectivity/network_status.dart';
import 'package:inblack_orders/features/orders/application/orders_list_controller.dart';
import 'package:inblack_orders/features/orders/application/orders_list_state.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/presentation/orders_list_screen.dart';
import 'package:inblack_orders/features/outbox/application/outbox_providers.dart';
import 'package:inblack_orders/features/realtime/application/realtime_providers.dart';
import 'package:inblack_orders/features/realtime/data/realtime_client.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../helpers/fake_outbox_actions.dart';

class _Controller extends OrdersListController {
  _Controller(this._state);

  final OrdersListState _state;

  @override
  OrdersListState build() => _state;

  @override
  Future<void> loadMore() async {}

  @override
  void setAtTop({required bool atTop}) {}
}

class _NoRealtime implements RealtimeControl {
  @override
  Future<void> setEnabled({required bool enabled}) async {}

  @override
  void setForeground({required bool foreground}) {}
}

final _now = DateTime.utc(2026, 11, 6, 12);

OrderSummary _order(int i, String status, String name, {int lines = 1}) =>
    OrderSummary(
      id: 'ORD-10004$i',
      status: status,
      version: 1,
      totalMinor: 17900 * (i + 1),
      lineCount: lines,
      itemCount: lines,
      primaryItem: PrimaryItem(sku: 'DM-0520', name: name),
      createdAt: _now.subtract(Duration(hours: i * 7)),
      updatedAt: _now,
    );

final List<OrderSummary> _rows = [
  _order(0, 'PENDING', 'Diamond Pack 520 💎', lines: 3),
  _order(1, 'PAID', 'Monthly Pass 30 วัน'),
  _order(2, 'IN_PROGRESS', 'บัตรของขวัญ 300 บาท'),
  _order(3, 'COMPLETED', 'Gift Card 1,000 THB'),
  _order(4, 'ON_HOLD', 'Diamond Pack 100 💎'),
];

void main() {
  setUpAll(() => initializeDateFormatting('th'));

  Future<void> pump(
    WidgetTester tester, {
    required ThemeMode mode,
    double textScale = 1,
    List<OrderSummary>? rows,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordersListControllerProvider.overrideWith(
            () => _Controller(
              OrdersListState(
                rowsLoaded: true,
                rows: rows ?? _rows,
                pendingIds: {'ORD-100041'},
                summary: const OrdersSummary(
                  counts: {'PENDING': 4, 'PAID': 10, 'ON_HOLD': 1},
                  total: 15,
                  syncSeq: 1,
                ),
              ),
            ),
          ),
          clockProvider.overrideWithValue(() => _now),
          realtimeControlProvider.overrideWithValue(_NoRealtime()),
          connectionStatusProvider.overrideWith(
            (ref) => Stream.value(ConnectionStatus.live),
          ),
          networkOnlineProvider.overrideWith((ref) => Stream.value(true)),
          outboxActionsProvider.overrideWithValue(FakeOutboxActions()),
          outboxItemsProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('th'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(colorSchemeSeed: Colors.indigo),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
          ),
          themeMode: mode,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child ?? const SizedBox.shrink(),
          ),
          home: const OrdersListScreen(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('orders list - light', (tester) async {
    await pump(tester, mode: ThemeMode.light);
    await expectLater(
      find.byType(OrdersListScreen),
      matchesGoldenFile('goldens/orders_list_light.png'),
    );
  });

  testWidgets('orders list - dark', (tester) async {
    await pump(tester, mode: ThemeMode.dark);
    await expectLater(
      find.byType(OrdersListScreen),
      matchesGoldenFile('goldens/orders_list_dark.png'),
    );
  });

  testWidgets('orders list - long Thai text at 200%', (tester) async {
    await pump(
      tester,
      mode: ThemeMode.light,
      textScale: 2,
      rows: [
        _order(
          0,
          'IN_PROGRESS',
          'บัตรของขวัญสำหรับเติมเกมรุ่นพิเศษสุดยอด 🎁🎮 ใช้ได้ทุกเซิร์ฟเวอร์ทั่วประเทศไทย',
          lines: 4,
        ),
        _order(1, 'REFUNDED', 'แพ็กเกจรายเดือนแบบพรีเมียมสำหรับผู้เล่นตัวจริง'),
      ],
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(OrdersListScreen),
      matchesGoldenFile('goldens/orders_list_thai_200.png'),
    );
  });
}
