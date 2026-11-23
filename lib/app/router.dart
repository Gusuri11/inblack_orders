import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inblack_orders/features/auth/presentation/login_screen.dart';
import 'package:inblack_orders/features/orders/presentation/order_detail_screen.dart';
import 'package:inblack_orders/features/orders/presentation/orders_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/orders',
        builder: (_, _) => const OrdersListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) =>
                OrderDetailScreen(orderId: state.pathParameters['id'] ?? ''),
          ),
        ],
      ),
    ],
  );
});
