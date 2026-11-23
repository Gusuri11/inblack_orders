import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/app/app.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';

import 'helpers/memory_token_storage.dart';

class _NoLinks implements LinkSource {
  @override
  Future<Uri?> initial() async => null;

  @override
  Stream<Uri> get links => const Stream.empty();
}

void main() {
  testWidgets('app without a session lands on the login screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStorageProvider.overrideWithValue(MemoryTokenStorage()),
          linkSourceProvider.overrideWithValue(_NoLinks()),
        ],
        child: const InBlackOrdersApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
