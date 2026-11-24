import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/app/app.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/core/settings/app_settings.dart';
import 'package:inblack_orders/features/auth/application/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
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

  testWidgets('language setting switches the UI to English', (tester) async {
    SharedPreferences.setMockInitialValues({'settings.language': 'en'});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tokenStorageProvider.overrideWithValue(MemoryTokenStorage()),
          linkSourceProvider.overrideWithValue(_NoLinks()),
        ],
        child: const InBlackOrdersApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign in to track your orders'), findsOneWidget);
  });
}
