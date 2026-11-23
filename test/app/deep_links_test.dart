import 'package:flutter_test/flutter_test.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/app/router.dart';
import 'package:inblack_orders/features/auth/application/auth_status.dart';

void main() {
  group('deepLinkToLocation', () {
    String? map(String s) => deepLinkToLocation(Uri.parse(s));

    test('order detail', () {
      expect(map('inblack://orders/ORD-100042'), '/orders/ORD-100042');
      expect(map('inblack:///orders/ORD-1'), '/orders/ORD-1');
    });

    test('status filter, normalised and sanitised', () {
      expect(
        map('inblack://orders?status=PAID,IN_PROGRESS'),
        '/orders?status=PAID,IN_PROGRESS',
      );
      expect(map('inblack://orders?status=paid, ,<x>'), '/orders?status=PAID');
      expect(map('inblack://orders'), '/orders');
    });

    test('ids are encoded', () {
      expect(map('inblack://orders/A%20B'), '/orders/A%20B');
    });

    test('foreign or malformed links are ignored', () {
      expect(map('https://evil.example/orders/1'), isNull);
      expect(map('inblack://settings'), isNull);
      expect(map('inblack://orders/1/2/3'), isNull);
    });
  });

  group('safeRedirectTarget', () {
    test('only in-app order paths are allowed', () {
      expect(safeRedirectTarget('/orders/ORD-1'), '/orders/ORD-1');
      expect(safeRedirectTarget('/orders?status=PAID'), '/orders?status=PAID');
      expect(safeRedirectTarget('https://evil.example'), isNull);
      expect(safeRedirectTarget('//evil.example/orders'), isNull);
      expect(safeRedirectTarget('/login'), isNull);
      expect(safeRedirectTarget(null), isNull);
    });
  });

  group('authRedirect', () {
    String? go(AuthPhase p, String loc) => authRedirect(p, Uri.parse(loc));

    test('while the session is loading everything waits on the splash', () {
      expect(
        go(AuthPhase.unknown, '/orders/ORD-1'),
        '/splash?from=%2Forders%2FORD-1',
      );
      expect(go(AuthPhase.unknown, '/splash?from=/orders'), isNull);
    });

    test('signed out: remember where the user wanted to go', () {
      expect(
        go(AuthPhase.signedOut, '/orders/ORD-1'),
        '/login?from=%2Forders%2FORD-1',
      );
      expect(
        go(AuthPhase.signedOut, '/splash?from=%2Forders%3Fstatus%3DPAID'),
        '/login?from=%2Forders%3Fstatus%3DPAID',
      );
      expect(go(AuthPhase.signedOut, '/orders'), '/login');
      expect(go(AuthPhase.signedOut, '/login?from=/orders/1'), isNull);
    });

    test('signed in: continue to the remembered destination', () {
      expect(
        go(AuthPhase.signedIn, '/login?from=%2Forders%2FORD-1'),
        '/orders/ORD-1',
      );
      expect(go(AuthPhase.signedIn, '/splash'), '/orders');
      expect(go(AuthPhase.signedIn, '/login?from=https://evil'), '/orders');
      expect(go(AuthPhase.signedIn, '/orders/ORD-1'), isNull);
    });
  });
}
