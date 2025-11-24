import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/resident/community/pages/community_screen.dart';
import 'package:rukunin/pages/rt/rt_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_list_screen.dart';
import 'package:rukunin/pages/rt/rt_shell.dart';
import 'package:rukunin/modules/marketplace/models/shop.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';
import 'package:rukunin/modules/marketplace/pages/marketplace_screen.dart';
import 'package:rukunin/modules/marketplace/pages/shop_dashboard_screen.dart';
import 'package:rukunin/modules/marketplace/pages/my_products_screen.dart';
import 'package:rukunin/modules/marketplace/pages/add_product_screen.dart';
import 'package:rukunin/modules/marketplace/pages/orders_screen.dart';
import 'package:rukunin/modules/marketplace/pages/search_results_screen.dart';
import 'package:rukunin/modules/marketplace/pages/cart_screen.dart';
import 'package:rukunin/modules/marketplace/pages/product_detail_screen.dart';
import 'package:rukunin/modules/activities/pages/activity_screen.dart';

final rtRoutes = [
  // Main routes with bottom navigation
  ShellRoute(
    builder: (context, state, child) => RtShell(child: child),
    routes: [
      GoRoute(
        path: '/rt',
        name: 'rt-home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RtHomeScreen()),
      ),
      GoRoute(
        path: '/rt/marketplace',
        name: 'rt-marketplace',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MarketplaceScreen()),
      ),
      GoRoute(
        path: '/rt/activities',
        name: 'rt-activities',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ActivityScreen()),
      ),
      GoRoute(
        path: '/rt/community',
        name: 'rt-community',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CommunityScreen()),
      ),
      GoRoute(
        path: '/rt/account',
        name: 'rt-account',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountScreen()),
      ),
    ],
  ),

  // Deep-link routes without bottom navigation - Marketplace
  GoRoute(
    path: '/rt/marketplace/product/:productId',
    name: 'rt-product-detail',
    builder: (context, state) {
      final product = state.extra as Product;
      return ProductDetailScreen(product: product);
    },
  ),
  GoRoute(
    path: '/rt/marketplace/search',
    name: 'rt-marketplace-search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchResultsScreen(initialQuery: query);
    },
  ),
  GoRoute(
    path: '/rt/marketplace/cart',
    name: 'rt-marketplace-cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/rt/marketplace/shop/:shopId/dashboard',
    name: 'rt-shop-dashboard',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return ShopDashboardScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rt/marketplace/shop/:shopId/products',
    name: 'rt-shop-products',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return MyProductsScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rt/marketplace/shop/:shopId/products/add',
    name: 'rt-shop-add-product',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return AddProductScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rt/marketplace/shop/:shopId/orders',
    name: 'rt-shop-orders',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return OrdersScreen(shop: shop);
    },
  ),

  // Resident data management
  GoRoute(
    path: '/rt/warga',
    name: 'rt-warga',
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: WargaListScreen()),
  ),
];
