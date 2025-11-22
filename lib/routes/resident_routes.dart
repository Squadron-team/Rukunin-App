import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/resident/community/community_screen.dart';
import 'package:rukunin/pages/resident/community/dues_screen.dart';
import 'package:rukunin/pages/resident/community/finance_transparency_screen.dart';
import 'package:rukunin/pages/resident/community/population_info_screen.dart';
import 'package:rukunin/pages/resident/resident_home_screen.dart';
import 'package:rukunin/modules/marketplace/marketplace_screen.dart';
import 'package:rukunin/modules/marketplace/shop_dashboard_screen.dart';
import 'package:rukunin/modules/marketplace/my_products_screen.dart';
import 'package:rukunin/modules/marketplace/add_product_screen.dart';
import 'package:rukunin/modules/marketplace/orders_screen.dart';
import 'package:rukunin/modules/marketplace/search_results_screen.dart';
import 'package:rukunin/modules/marketplace/cart_screen.dart';
import 'package:rukunin/pages/resident/activities/activity_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/resident/resident_shell.dart';
import 'package:rukunin/pages/resident/community/family_details_screen.dart';
import 'package:rukunin/pages/resident/community/documents_screen.dart';
import 'package:rukunin/pages/resident/community/document_request_form_screen.dart';
import 'package:rukunin/models/shop.dart';

final residentRoutes = [
  // Main routes with bottom navigation
  ShellRoute(
    builder: (context, state, child) => ResidentShell(child: child),
    routes: [
      GoRoute(
        path: '/resident',
        name: 'resident-home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ResidentHomeScreen(),
        ),
      ),
      GoRoute(
        path: '/resident/marketplace',
        name: 'resident-marketplace',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MarketplaceScreen(),
        ),
      ),
      GoRoute(
        path: '/resident/activities',
        name: 'resident-activities',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ActivityScreen(),
        ),
      ),
      GoRoute(
        path: '/resident/community',
        name: 'resident-community',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CommunityScreen(),
        ),
      ),
      GoRoute(
        path: '/resident/account',
        name: 'resident-account',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AccountScreen(),
        ),
      ),
    ],
  ),

  // Deep-link routes without bottom navigation - Marketplace
  GoRoute(
    path: '/resident/marketplace/search',
    name: 'resident-marketplace-search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchResultsScreen(initialQuery: query);
    },
  ),
  GoRoute(
    path: '/resident/marketplace/cart',
    name: 'resident-marketplace-cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/resident/marketplace/shop/:shopId/dashboard',
    name: 'resident-shop-dashboard',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return ShopDashboardScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/resident/marketplace/shop/:shopId/products',
    name: 'resident-shop-products',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return MyProductsScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/resident/marketplace/shop/:shopId/products/add',
    name: 'resident-shop-add-product',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return AddProductScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/resident/marketplace/shop/:shopId/orders',
    name: 'resident-shop-orders',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return OrdersScreen(shop: shop);
    },
  ),

  // Deep-link routes without bottom navigation - Community
  GoRoute(
    path: '/resident/community/dues',
    name: 'resident-community-dues',
    builder: (context, state) => const DuesScreen(),
  ),
  GoRoute(
    path: '/resident/community/finance-transparency',
    name: 'resident-community-finance',
    builder: (context, state) => const FinanceTransparencyScreen(),
  ),
  GoRoute(
    path: '/resident/community/population',
    name: 'resident-community-population',
    builder: (context, state) => const PopulationInfoScreen(),
  ),
  GoRoute(
    path: '/resident/community/family',
    name: 'resident-community-family',
    builder: (context, state) => const FamilyDetailsScreen(),
  ),
  GoRoute(
    path: '/resident/community/documents',
    name: 'resident-community-documents',
    builder: (context, state) => const DocumentsScreen(),
  ),
  GoRoute(
    path: '/resident/community/documents/domicile',
    name: 'resident-ocument-domicile',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'domicile',
      documentTitle: 'Surat Keterangan Domisili',
      documentIcon: Icons.home_outlined,
      documentColor: Colors.blue,
    ),
  ),
  GoRoute(
    path: '/resident/community/documents/sktm',
    name: 'resident-document-sktm',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'sktm',
      documentTitle: 'Surat Keterangan Tidak Mampu',
      documentIcon: Icons.people_outline,
      documentColor: Colors.orange,
    ),
  ),
  GoRoute(
    path: '/resident/community/documents/business',
    name: 'resident-document-business',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'business',
      documentTitle: 'Surat Keterangan Usaha',
      documentIcon: Icons.business_outlined,
      documentColor: Colors.green,
    ),
  ),
  GoRoute(
    path: '/resident/community/documents/correction',
    name: 'resident-document-correction',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'correction',
      documentTitle: 'Permohonan Koreksi Data',
      documentIcon: Icons.edit_document,
      documentColor: Colors.purple,
    ),
  ),
  GoRoute(
    path: '/resident/community/documents/family',
    name: 'resident-document-family',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'family',
      documentTitle: 'Surat Keterangan Keluarga',
      documentIcon: Icons.family_restroom,
      documentColor: Colors.teal,
    ),
  ),
  GoRoute(
    path: '/resident/community/documents/other',
    name: 'resident-document-other',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'other',
      documentTitle: 'Surat Lainnya',
      documentIcon: Icons.description_outlined,
      documentColor: Colors.grey,
    ),
  ),
];
