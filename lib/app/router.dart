import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/app/deep_links.dart';
import 'package:inblack_orders/features/auth/application/auth_status.dart';
import 'package:inblack_orders/features/auth/presentation/login_screen.dart';
import 'package:inblack_orders/features/orders/presentation/order_detail_screen.dart';
import 'package:inblack_orders/features/orders/presentation/orders_list_screen.dart';
import 'package:inblack_orders/features/outbox/presentation/outbox_screen.dart';

class _AuthRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh();
  ref
    ..listen(authStatusProvider, (_, _) => refresh.ping())
    ..onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/orders',
    refreshListenable: refresh,
    redirect: (context, state) =>
        authRedirect(ref.read(authStatusProvider).phase, state.uri),
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const _SplashScreen()),
      GoRoute(
        path: '/login',
        builder: (_, state) =>
            LoginScreen(from: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: '/orders',
        builder: (_, state) =>
            OrdersListScreen(statusFilter: state.uri.queryParameters['status']),
        routes: [
          GoRoute(path: 'outbox', builder: (_, _) => const OutboxScreen()),
          GoRoute(
            path: ':id',
            builder: (_, state) =>
                OrderDetailScreen(orderId: state.pathParameters['id'] ?? ''),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

String? authRedirect(AuthPhase phase, Uri uri) {
  final path = uri.path;
  final here = uri.toString();
  final from = uri.queryParameters['from'];

  switch (phase) {
    case AuthPhase.unknown:
      if (path == '/splash') return null;
      return Uri(path: '/splash', queryParameters: {'from': here}).toString();
    case AuthPhase.signedOut:
      if (path == '/login') return null;
      final target = path == '/splash' ? safeRedirectTarget(from) : here;
      return target == null || target == '/orders'
          ? '/login'
          : Uri(path: '/login', queryParameters: {'from': target}).toString();
    case AuthPhase.signedIn:
      if (path == '/login' || path == '/splash') {
        return safeRedirectTarget(from) ?? '/orders';
      }
      return null;
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
