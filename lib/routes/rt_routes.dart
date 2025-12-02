import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/modules/community/pages/community_screen.dart';
import 'package:rukunin/pages/rt/rt_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_list_screen.dart';
import 'package:rukunin/pages/rt/warga/list_keluarga/family_list_screen.dart';
import 'package:rukunin/pages/rt/wilayah/wilayah_rt_screen.dart';
import 'package:rukunin/pages/rt/events/events_screen.dart';
import 'package:rukunin/pages/rt/reports/manage_reports_screen.dart';
import 'package:rukunin/pages/rt/surat_to_rw/screen.dart';
import 'package:rukunin/pages/rt/announcements/announcements_screen.dart';
import 'package:rukunin/pages/rt/surat_form_warga/kelola_pengajuan_surat_screen.dart';
import 'package:rukunin/pages/rt/mutasi/mutasi_list_screen.dart';
import 'package:rukunin/pages/rt/report_statistic/laporan_rt_screen.dart';
import 'package:rukunin/pages/rt/meetings/meetings_screen.dart';
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
import 'package:rukunin/widgets/rukunin_app_bar.dart';

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

  // RT Feature routes
  GoRoute(
    path: '/rt/warga/list',
    name: 'rt-warga-list',
    builder: (context, state) => const WargaListScreen(),
  ),
  GoRoute(
    path: '/rt/warga/family',
    name: 'rt-warga-family',
    builder: (context, state) => const FamilyListScreen(),
  ),
  GoRoute(
    path: '/rt/wilayah',
    name: 'rt-wilayah',
    builder: (context, state) => const WilayahRtScreen(),
  ),
  GoRoute(
    path: '/rt/events',
    name: 'rt-events',
    builder: (context, state) => const CommunityHeadEventsScreen(),
  ),
  GoRoute(
    path: '/rt/iuran',
    name: 'rt-iuran',
    builder: (context, state) => const Scaffold(
      appBar: RukuninAppBar(title: 'Iuran Warga'),
      body: Placeholder(),
    ), // TODO: Create IuranScreen
  ),
  GoRoute(
    path: '/rt/reports/manage',
    name: 'rt-reports-manage',
    builder: (context, state) => const ManageReportsScreen(),
  ),
  GoRoute(
    path: '/rt/surat/create',
    name: 'rt-surat-create',
    builder: (context, state) => const CreateRtToRwLetterScreen(),
  ),
  GoRoute(
    path: '/rt/announcements',
    name: 'rt-announcements',
    builder: (context, state) => const AnnouncementsScreen(),
  ),
  GoRoute(
    path: '/rt/surat/pengajuan',
    name: 'rt-surat-pengajuan',
    builder: (context, state) => const KelolaPengajuanSuratScreen(),
  ),
  GoRoute(
    path: '/rt/mutasi',
    name: 'rt-mutasi',
    builder: (context, state) => const MutasiListScreen(),
  ),
  GoRoute(
    path: '/rt/reports/statistic',
    name: 'rt-reports-statistic',
    builder: (context, state) => const LaporanRTScreen(),
  ),
  GoRoute(
    path: '/rt/meetings',
    name: 'rt-meetings',
    builder: (context, state) => const MeetingsScreen(),
  ),
];
