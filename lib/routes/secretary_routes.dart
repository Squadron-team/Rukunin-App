import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/modules/activities/pages/activity_screen.dart';
import 'package:rukunin/modules/community/pages/community_screen.dart';
import 'package:rukunin/modules/community/pages/document_request_form_screen.dart';
import 'package:rukunin/modules/community/pages/documents_screen.dart';
import 'package:rukunin/modules/community/pages/dues_screen.dart';
import 'package:rukunin/modules/community/pages/family_details_screen.dart';
import 'package:rukunin/modules/community/pages/finance_transparency_screen.dart';
import 'package:rukunin/modules/community/pages/population_info_screen.dart';
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
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/secretary/secretary_shell.dart';

final secretaryRoutes = [
  // Main routes with bottom navigation
  ShellRoute(
    builder: (context, state, child) => SecretaryShell(child: child),
    routes: [
      GoRoute(
        path: '/secretary',
        name: 'secretary-home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SecretaryHomeScreen()),
      ),
      GoRoute(
        path: '/secretary/marketplace',
        name: 'secretary-marketplace',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MarketplaceScreen()),
      ),
      GoRoute(
        path: '/secretary/activities',
        name: 'secretary-activities',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ActivityScreen()),
      ),
      GoRoute(
        path: '/secretary/community',
        name: 'secretary-community',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CommunityScreen()),
      ),
      GoRoute(
        path: '/secretary/account',
        name: 'secretary-account',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountScreen()),
      ),
    ],
  ),

  // Deep-link routes without bottom navigation - Marketplace
  GoRoute(
    path: '/secretary/marketplace/product/:productId',
    name: 'secretary-product-detail',
    builder: (context, state) {
      final product = state.extra as Product;
      return ProductDetailScreen(product: product);
    },
  ),
  GoRoute(
    path: '/secretary/marketplace/search',
    name: 'secretary-marketplace-search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchResultsScreen(initialQuery: query);
    },
  ),
  GoRoute(
    path: '/secretary/marketplace/cart',
    name: 'secretary-marketplace-cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/secretary/marketplace/shop/:shopId/dashboard',
    name: 'secretary-shop-dashboard',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return ShopDashboardScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/secretary/marketplace/shop/:shopId/products',
    name: 'secretary-shop-products',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return MyProductsScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/secretary/marketplace/shop/:shopId/products/add',
    name: 'secretary-shop-add-product',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return AddProductScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/secretary/marketplace/shop/:shopId/orders',
    name: 'secretary-shop-orders',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return OrdersScreen(shop: shop);
    },
  ),

  // Deep-link routes without bottom navigation - Community
  GoRoute(
    path: '/secretary/community/dues',
    name: 'secretary-community-dues',
    builder: (context, state) => const DuesScreen(),
  ),
  GoRoute(
    path: '/secretary/community/finance-transparency',
    name: 'secretary-community-finance',
    builder: (context, state) => const FinanceTransparencyScreen(),
  ),
  GoRoute(
    path: '/secretary/community/population',
    name: 'secretary-community-population',
    builder: (context, state) => const PopulationInfoScreen(),
  ),
  GoRoute(
    path: '/secretary/community/family',
    name: 'secretary-community-family',
    builder: (context, state) => const FamilyDetailsScreen(),
  ),
  GoRoute(
    path: '/secretary/community/documents',
    name: 'secretary-community-documents',
    builder: (context, state) => const DocumentsScreen(),
  ),
  GoRoute(
    path: '/secretary/community/documents/domicile',
    name: 'secretary-document-domicile',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'domicile',
      documentTitle: 'Surat Keterangan Domisili',
      documentIcon: Icons.home_outlined,
      documentColor: Colors.blue,
    ),
  ),
  GoRoute(
    path: '/secretary/community/documents/sktm',
    name: 'secretary-document-sktm',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'sktm',
      documentTitle: 'Surat Keterangan Tidak Mampu',
      documentIcon: Icons.people_outline,
      documentColor: Colors.orange,
    ),
  ),
  GoRoute(
    path: '/secretary/community/documents/business',
    name: 'secretary-document-business',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'business',
      documentTitle: 'Surat Keterangan Usaha',
      documentIcon: Icons.business_outlined,
      documentColor: Colors.green,
    ),
  ),
  GoRoute(
    path: '/secretary/community/documents/correction',
    name: 'secretary-document-correction',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'correction',
      documentTitle: 'Permohonan Koreksi Data',
      documentIcon: Icons.edit_document,
      documentColor: Colors.purple,
    ),
  ),
  GoRoute(
    path: '/secretary/community/documents/family',
    name: 'secretary-document-family',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'family',
      documentTitle: 'Surat Keterangan Keluarga',
      documentIcon: Icons.family_restroom,
      documentColor: Colors.teal,
    ),
  ),
  GoRoute(
    path: '/secretary/community/documents/other',
    name: 'secretary-document-other',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'other',
      documentTitle: 'Surat Lainnya',
      documentIcon: Icons.description_outlined,
      documentColor: Colors.grey,
    ),
  ),
];
