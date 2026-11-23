import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/features/orders/application/order_detail_controller.dart';
import 'package:inblack_orders/features/orders/data/order_models.dart';
import 'package:inblack_orders/features/orders/presentation/order_detail_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeDetail extends OrderDetailController {
  _FakeDetail(super.orderId, this._state);

  final OrderDetailState _state;
  int fetches = 0;

  @override
  OrderDetailState build() => _state;

  @override
  Future<void> fetch() async => fetches++;
}

final _at = DateTime.utc(2026, 11, 6, 3);

OrderDetail _detail({
  String name = 'Diamond Pack 520 💎',
  String note = 'ขอบคุณครับ',
}) => OrderDetail(
  id: 'ORD-100042',
  status: 'PAID',
  version: 2,
  totalMinor: 35800,
  createdAt: _at,
  updatedAt: _at,
  playerId: '51234567',
  channel: 'APP',
  items: [
    OrderLine(sku: 'DM-0520', name: name, quantity: 2, unitPriceMinor: 17900),
  ],
  history: [
    OrderHistoryEntry(status: 'PENDING', at: _at, by: 'system'),
    OrderHistoryEntry(
      status: 'PAID',
      at: _at,
      by: 'customer',
      note: 'ชำระผ่านบัตร',
    ),
  ],
  notes: [OrderNote(id: 'n1', text: note, author: 'support', createdAt: _at)],
);

void main() {
  setUpAll(() => initializeDateFormatting('th'));

  late List<String> shared;

  Future<void> pump(
    WidgetTester tester,
    OrderDetailState state, {
    double textScale = 1,
  }) async {
    shared = [];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderDetailControllerProvider('ORD-100042')
              .overrideWith(() => _FakeDetail('ORD-100042', state)),
          shareTextProvider.overrideWithValue((text) async => shared.add(text)),
        ],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child ?? const SizedBox.shrink(),
          ),
          home: const OrderDetailScreen(orderId: 'ORD-100042'),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows totals, items, timeline and notes', (tester) async {
    await pump(tester, OrderDetailState(detail: _detail(), loading: false));
    expect(find.text('฿358.00'), findsNWidgets(2));
    expect(find.text('2 × ฿179.00'), findsOneWidget);
    expect(find.text('51234567'), findsOneWidget);
    expect(find.text('ชำระผ่านบัตร'), findsOneWidget);
    expect(find.text('ขอบคุณครับ'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('ไม่มีไฟล์แนบ'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('ไม่มีไฟล์แนบ'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('สถานะ: ชำระเงินแล้ว')),
      findsOneWidget,
    );
  });

  testWidgets('a newer live status overrides the cached one', (tester) async {
    await pump(
      tester,
      OrderDetailState(
        detail: _detail(),
        loading: false,
        liveStatus: 'COMPLETED',
        liveVersion: 3,
      ),
    );
    expect(find.bySemanticsLabel(RegExp('สถานะ: สำเร็จ')), findsOneWidget);
  });

  testWidgets('copy puts the id on the clipboard and confirms', (tester) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    await pump(tester, OrderDetailState(detail: _detail(), loading: false));
    await tester.tap(find.byTooltip('คัดลอกเลขคำสั่งซื้อ'));
    await tester.pump();
    expect(
      calls.where((c) => c.method == 'Clipboard.setData').single.arguments,
      {'text': 'ORD-100042'},
    );
    expect(find.text('คัดลอกเลขคำสั่งซื้อ ORD-100042 แล้ว'), findsOneWidget);
  });

  testWidgets('share sends the deep link', (tester) async {
    await pump(tester, OrderDetailState(detail: _detail(), loading: false));
    await tester.tap(find.byTooltip('แชร์ลิงก์คำสั่งซื้อ'));
    await tester.pump();
    expect(shared, ['inblack://orders/ORD-100042']);
  });

  testWidgets('not found page', (tester) async {
    await pump(tester, const OrderDetailState(loading: false, notFound: true));
    expect(find.text('ไม่พบคำสั่งซื้อ'), findsOneWidget);
    expect(find.text('กลับไปหน้ารายการ'), findsOneWidget);
    expect(find.byTooltip('คัดลอกเลขคำสั่งซื้อ'), findsNothing);
  });

  testWidgets('deleted while viewing shows a polite banner over the content', (
    tester,
  ) async {
    await pump(
      tester,
      OrderDetailState(detail: _detail(), loading: false, deleted: true),
    );
    expect(find.textContaining('ถูกลบออกจากระบบแล้ว'), findsOneWidget);
    expect(find.text('฿358.00'), findsNWidgets(2));
  });

  testWidgets('long Thai text with emoji at 200% does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pump(
      tester,
      OrderDetailState(
        detail: _detail(
          name: 'บัตรของขวัญสำหรับเติมเกมรุ่นพิเศษสุดยอด 🎁🎮✨ ใช้ได้ทุกเซิร์ฟเวอร์ทั่วประเทศไทยและต่างประเทศ',
          note: 'ข้อความยาวมาก ' * 40,
        ),
        loading: false,
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });
}
