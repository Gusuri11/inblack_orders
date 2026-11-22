import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/main.dart';

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(const InBlackOrdersApp());
    expect(find.byType(InBlackOrdersApp), findsOneWidget);
  });
}
