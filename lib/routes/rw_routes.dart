import 'package:go_router/go_router.dart';
import 'package:rukunin/modules/activities/pages/activity_screen.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';
import 'package:rukunin/modules/marketplace/models/shop.dart';
import 'package:rukunin/modules/marketplace/pages/add_product_screen.dart';
import 'package:rukunin/modules/marketplace/pages/cart_screen.dart';
import 'package:rukunin/modules/marketplace/pages/marketplace_screen.dart';
import 'package:rukunin/modules/marketplace/pages/my_products_screen.dart';
import 'package:rukunin/modules/marketplace/pages/orders_screen.dart';
import 'package:rukunin/modules/marketplace/pages/product_detail_screen.dart';
import 'package:rukunin/modules/marketplace/pages/search_results_screen.dart';
import 'package:rukunin/modules/marketplace/pages/shop_dashboard_screen.dart';
import 'package:rukunin/modules/community/pages/community_screen.dart';
import 'package:rukunin/pages/rw/data_warga/data_warga_screen.dart';
import 'package:rukunin/pages/rw/iuran/iuran_rw_screen.dart';
import 'package:rukunin/pages/rw/kegiatan/kegiatan_rw_screen.dart';
import 'package:rukunin/pages/rw/laporan/kelola_laporan_screen.dart';
import 'package:rukunin/pages/rw/pengumuman/pengumuman_screen.dart';
import 'package:rukunin/pages/rw/rapat/rapat_rw_screen.dart';
import 'package:rukunin/pages/rw/surat/surat_menyurat_screen.dart';
import 'package:rukunin/pages/rw/rw_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/rw/rw_shell.dart';

final rwRoutes = [
  // Main routes with bottom navigation
  ShellRoute(
    builder: (context, state, child) => RwShell(child: child),
    routes: [
      GoRoute(
        path: '/rw',
        name: 'rw-home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RwHomeScreen()),
      ),
      GoRoute(
        path: '/rw/marketplace',
        name: 'rw-marketplace',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MarketplaceScreen()),
      ),
      GoRoute(
        path: '/rw/activities',
        name: 'rw-activities',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ActivityScreen()),
      ),
      GoRoute(
        path: '/rw/community',
        name: 'rw-community',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CommunityScreen()),
      ),
      GoRoute(
        path: '/rw/account',
        name: 'rw-account',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountScreen()),
      ),
    ],
  ),

  // Deep-link routes without bottom navigation - Marketplace
  GoRoute(
    path: '/rw/marketplace/product/:productId',
    name: 'rw-product-detail',
    builder: (context, state) {
      final product = state.extra as Product;
      return ProductDetailScreen(product: product);
    },
  ),
  GoRoute(
    path: '/rw/marketplace/search',
    name: 'rw-marketplace-search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchResultsScreen(initialQuery: query);
    },
  ),
  GoRoute(
    path: '/rw/marketplace/cart',
    name: 'rw-marketplace-cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/rw/marketplace/shop/:shopId/dashboard',
    name: 'rw-shop-dashboard',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return ShopDashboardScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rw/marketplace/shop/:shopId/products',
    name: 'rw-shop-products',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return MyProductsScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rw/marketplace/shop/:shopId/products/add',
    name: 'rw-shop-add-product',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return AddProductScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/rw/marketplace/shop/:shopId/orders',
    name: 'rw-shop-orders',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return OrdersScreen(shop: shop);
    },
  ),

  // RW Feature routes
  GoRoute(
    path: '/rw/data-warga',
    name: 'rw-data-warga',
    builder: (context, state) => const DataWargaScreen(),
  ),
  GoRoute(
    path: '/rw/iuran',
    name: 'rw-iuran',
    builder: (context, state) => const IuranRwScreen(),
  ),
  GoRoute(
    path: '/rw/kegiatan',
    name: 'rw-kegiatan',
    builder: (context, state) => const KegiatanRwScreen(),
  ),
  GoRoute(
    path: '/rw/laporan',
    name: 'rw-laporan',
    builder: (context, state) => const KelolaLaporanScreen(),
  ),
  GoRoute(
    path: '/rw/pengumuman',
    name: 'rw-pengumuman',
    builder: (context, state) => const PengumumanScreen(),
  ),
  GoRoute(
    path: '/rw/rapat',
    name: 'rw-rapat',
    builder: (context, state) => const RapatRwScreen(),
  ),
  GoRoute(
    path: '/rw/surat',
    name: 'rw-surat',
    builder: (context, state) => const SuratMenyuratScreen(),
  ),
];
