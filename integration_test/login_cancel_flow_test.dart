import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/app/app.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/core/config/app_config.dart';
import 'package:inblack_orders/core/database/app_database.dart';
import 'package:inblack_orders/core/database/database_providers.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:inblack_orders/features/auth/data/token_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryTokens implements TokenStorage {
  StoredSession? value;

  @override
  Future<StoredSession?> read() async => value;

  @override
  Future<void> save(StoredSession session) async => value = session;

  @override
  Future<void> clear() async => value = null;
}

class _NoLinks implements LinkSource {
  @override
  Future<Uri?> initial() async => null;

  @override
  Stream<Uri> get links => const Stream.empty();
}

Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login → list → detail → cancel (against the mock server)', (
    tester,
  ) async {
    await initializeDateFormatting();
    final admin = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
    final created = await admin.post<Map<String, dynamic>>(
      '/admin/create',
      data: {'username': 'bob'},
    );
    final orderId = '${created.data?['id']}';

    SharedPreferences.setMockInitialValues({'settings.notification_prompt': true});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tokenStorageProvider.overrideWithValue(_MemoryTokens()),
          appDatabaseProvider.overrideWithValue(db),
          linkSourceProvider.overrideWithValue(_NoLinks()),
        ],
        child: const InBlackOrdersApp(),
      ),
    );
    await pumpUntil(tester, find.text('เข้าสู่ระบบ'));

    await tester.enterText(find.byType(TextField).at(0), 'bob');
    await tester.enterText(find.byType(TextField).at(1), 'bob1234');
    await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));

    final tile = find.text(orderId);
    await pumpUntil(tester, tile);
    await tester.tap(tile);

    final cancel = find.widgetWithText(OutlinedButton, 'ยกเลิกคำสั่งซื้อ');
    await pumpUntil(tester, cancel);
    await tester.ensureVisible(cancel);
    await tester.tap(cancel);

    await pumpUntil(tester, find.text('ยกเลิกคำสั่งซื้อ?'));
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'ทดสอบ E2E',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'ยืนยันยกเลิก'));

    await pumpUntil(tester, find.bySemanticsLabel(RegExp('สถานะ: ยกเลิกแล้ว')));

    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while ((await db.outboxDao.all()).isNotEmpty) {
      if (DateTime.now().isAfter(deadline)) fail('cancel was never sent');
      await tester.pump(const Duration(milliseconds: 300));
    }
    final row = await db.ordersDao.findById(orderId);
    expect(row?.status, 'CANCELLED');

    final state = await admin.get<Map<String, dynamic>>('/admin/state');
    final stats = state.data?['stats'] as Map<String, dynamic>?;
    expect(stats?['refreshReuseDetected'], 0);
  });
}
