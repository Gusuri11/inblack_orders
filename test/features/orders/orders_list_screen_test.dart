import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/features/orders/application/orders_list_controller.dart';
import 'package:inblack_orders/features/orders/application/orders_list_state.dart';
import 'package:inblack_orders/features/orders/application/orders_providers.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/presentation/orders_list_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeController extends OrdersListController {
  _FakeController(this._initial);

  final OrdersListState _initial;
  int retries = 0;

  @override
  OrdersListState build() => _initial;

  @override
  Future<void> loadMore() async {}

  @override
  void setAtTop({required bool atTop}) {}

  @override
  Future<void> retry() async => retries++;
}

final _now = DateTime.utc(2026, 11, 6, 12);

OrderSummary _order(
  String id, {
  String status = 'PAID',
  String name = 'Diamond Pack 520 💎',
  int lines = 1,
  Duration age = const Duration(minutes: 5),
}) => OrderSummary(
  id: id,
  status: status,
  version: 1,
  totalMinor: 123456,
  lineCount: lines,
  itemCount: lines,
  primaryItem: PrimaryItem(sku: 'DM-0520', name: name),
  createdAt: _now.subtract(age),
  updatedAt: _now.subtract(age),
);

void main() {
  setUpAll(() => initializeDateFormatting('th'));

  late _FakeController controller;

  Future<void> pump(
    WidgetTester tester,
    OrdersListState state, {
    double textScale = 1,
  }) async {
    controller = _FakeController(state);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordersListControllerProvider.overrideWith(() => controller),
          clockProvider.overrideWithValue(() => _now),
        ],
        child: MaterialApp(
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

  testWidgets('renders order rows with amount, badge and relative time', (
    tester,
  ) async {
    await pump(
      tester,
      OrdersListState(
        rowsLoaded: true,
        rows: [
          _order('ORD-1', lines: 3),
          _order(
            'ORD-2',
            status: 'SOMETHING_NEW',
            age: const Duration(days: 3),
          ),
        ],
        summary: const OrdersSummary(
          counts: {'PAID': 10, 'SOMETHING_NEW': 1},
          total: 11,
          syncSeq: 1,
        ),
      ),
    );

    expect(find.text('ORD-1'), findsOneWidget);
    expect(find.text('฿1,234.56'), findsNWidgets(2));
    expect(find.text('Diamond Pack 520 💎 (+2 รายการ)'), findsOneWidget);
    expect(find.text('5 นาทีที่แล้ว'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('สถานะ: ชำระเงินแล้ว')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('สถานะ: SOMETHING_NEW')), findsOneWidget);
    expect(find.text('ทั้งหมด (11)'), findsOneWidget);
    expect(find.text('SOMETHING_NEW (1)'), findsOneWidget);
    expect(find.text('แสดงครบทุกรายการแล้ว'), findsOneWidget);
  });

  testWidgets('initial loading', (tester) async {
    await pump(tester, const OrdersListState(syncing: true));
    expect(find.text('กำลังโหลดคำสั่งซื้อ…'), findsOneWidget);
  });

  testWidgets('full screen error with retry', (tester) async {
    await pump(
      tester,
      const OrdersListState(
        rowsLoaded: true,
        syncError: ApiException(isNetworkError: true),
      ),
    );
    expect(
      find.text('ไม่สามารถเชื่อมต่อได้ ตรวจสอบอินเทอร์เน็ตแล้วลองใหม่'),
      findsOneWidget,
    );
    await tester.tap(find.text('ลองใหม่'));
    expect(controller.retries, 1);
  });

  testWidgets('empty search result names the query', (tester) async {
    await pump(
      tester,
      const OrdersListState(rowsLoaded: true, activeQuery: 'zzz'),
    );
    expect(find.text('ไม่พบคำสั่งซื้อที่ตรงกับ “zzz”'), findsOneWidget);
  });

  testWidgets('footer error offers retry at the end of the list', (
    tester,
  ) async {
    await pump(
      tester,
      OrdersListState(
        rowsLoaded: true,
        rows: [_order('ORD-1')],
        canLoadMoreRemote: true,
        remote: RemoteStatus.error,
        remoteError: const ApiException(statusCode: 503),
      ),
    );
    expect(
      find.text('โหลดเพิ่มไม่สำเร็จ: เซิร์ฟเวอร์ขัดข้องชั่วคราว กรุณาลองใหม่'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'ลองใหม่'));
    expect(controller.retries, 1);
  });

  testWidgets('offline banner, local results notice and new items banner', (
    tester,
  ) async {
    await pump(
      tester,
      OrdersListState(
        rowsLoaded: true,
        rows: [_order('ORD-1')],
        offline: true,
        activeQuery: 'gift',
        localSearch: true,
        newCount: 3,
        lastSyncedAt: DateTime.utc(2026, 11, 6, 3),
      ),
    );
    expect(find.textContaining('ออฟไลน์ · อัปเดตล่าสุดเมื่อ'), findsOneWidget);
    expect(find.textContaining('แสดงผลจากข้อมูลในเครื่อง'), findsOneWidget);
    expect(find.text('มี 3 รายการใหม่'), findsOneWidget);
  });

  testWidgets('long Thai names at 200% text do not overflow', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pump(
      tester,
      OrdersListState(
        rowsLoaded: true,
        rows: [
          _order(
            'ORD-100042',
            status: 'IN_PROGRESS',
            name: 'บัตรของขวัญสำหรับเติมเกมแบบพิเศษสุด ๆ 🎁🎮 ใช้ได้ทุกเซิร์ฟเวอร์ทั่วประเทศไทย',
            lines: 4,
          ),
        ],
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('ORD-100042'), findsOneWidget);
    expect(find.text('฿1,234.56'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('สถานะ: กำลังดำเนินการ')), findsOneWidget);
  });
}
