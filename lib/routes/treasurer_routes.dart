import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/modules/community/pages/community_screen.dart';
import 'package:rukunin/modules/community/pages/document_request_form_screen.dart';
import 'package:rukunin/modules/community/pages/documents_screen.dart';
import 'package:rukunin/modules/community/pages/dues_screen.dart';
import 'package:rukunin/modules/community/pages/family_details_screen.dart';
import 'package:rukunin/modules/community/pages/finance_transparency_screen.dart';
import 'package:rukunin/modules/community/pages/population_info_screen.dart';
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
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/treasurer/data_iuran/data_iuran_detail.dart';
import 'package:rukunin/pages/treasurer/data_iuran/data_iuran_page.dart';
import 'package:rukunin/pages/treasurer/pemasukan/pemasukan_screen.dart';
import 'package:rukunin/pages/treasurer/transactions/transaction_detail.dart';
import 'package:rukunin/pages/treasurer/transactions/transactions_page.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_shell.dart';
import 'package:rukunin/pages/treasurer/kategori/kategori_screen.dart';

final treasurerRoutes = [
  // Main routes with bottom navigation
  ShellRoute(
    builder: (context, state, child) => TreasurerShell(child: child),
    routes: [
      GoRoute(
        path: '/treasurer',
        name: 'treasurer-home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TreasurerHomeScreen()),
      ),
      GoRoute(
        path: '/treasurer/marketplace',
        name: 'treasurer-marketplace',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MarketplaceScreen()),
      ),
      GoRoute(
        path: '/treasurer/activities',
        name: 'treasurer-activities',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ActivityScreen()),
      ),
      GoRoute(
        path: '/treasurer/community',
        name: 'treasurer-community',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CommunityScreen()),
      ),
      GoRoute(
        path: '/treasurer/account',
        name: 'treasurer-account',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountScreen()),
      ),
    ],
  ),

  // Deep-link routes without bottom navigation - Marketplace
  GoRoute(
    path: '/treasurer/marketplace/product/:productId',
    name: 'treasurer-product-detail',
    builder: (context, state) {
      final product = state.extra as Product;
      return ProductDetailScreen(product: product);
    },
  ),
  GoRoute(
    path: '/treasurer/marketplace/search',
    name: 'treasurer-marketplace-search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchResultsScreen(initialQuery: query);
    },
  ),
  GoRoute(
    path: '/treasurer/marketplace/cart',
    name: 'treasurer-marketplace-cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/treasurer/marketplace/shop/:shopId/dashboard',
    name: 'treasurer-shop-dashboard',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return ShopDashboardScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/treasurer/marketplace/shop/:shopId/products',
    name: 'treasurer-shop-products',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return MyProductsScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/treasurer/marketplace/shop/:shopId/products/add',
    name: 'treasurer-shop-add-product',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return AddProductScreen(shop: shop);
    },
  ),
  GoRoute(
    path: '/treasurer/marketplace/shop/:shopId/orders',
    name: 'treasurer-shop-orders',
    builder: (context, state) {
      final shop = state.extra as Shop;
      return OrdersScreen(shop: shop);
    },
  ),

  // Deep-link routes without bottom navigation - Community
  GoRoute(
    path: '/treasurer/community/dues',
    name: 'treasurer-community-dues',
    builder: (context, state) => const DuesScreen(),
  ),
  GoRoute(
    path: '/treasurer/community/finance-transparency',
    name: 'treasurer-community-finance',
    builder: (context, state) => const FinanceTransparencyScreen(),
  ),
  GoRoute(
    path: '/treasurer/community/population',
    name: 'treasurer-community-population',
    builder: (context, state) => const PopulationInfoScreen(),
  ),
  GoRoute(
    path: '/treasurer/community/family',
    name: 'treasurer-community-family',
    builder: (context, state) => const FamilyDetailsScreen(),
  ),
  GoRoute(
    path: '/treasurer/community/documents',
    name: 'treasurer-community-documents',
    builder: (context, state) => const DocumentsScreen(),
  ),
  GoRoute(
    path: '/treasurer/community/documents/domicile',
    name: 'treasurer-document-domicile',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'domicile',
      documentTitle: 'Surat Keterangan Domisili',
      documentIcon: Icons.home_outlined,
      documentColor: Colors.blue,
    ),
  ),
  GoRoute(
    path: '/treasurer/community/documents/sktm',
    name: 'treasurer-document-sktm',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'sktm',
      documentTitle: 'Surat Keterangan Tidak Mampu',
      documentIcon: Icons.people_outline,
      documentColor: Colors.orange,
    ),
  ),
  GoRoute(
    path: '/treasurer/community/documents/business',
    name: 'treasurer-document-business',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'business',
      documentTitle: 'Surat Keterangan Usaha',
      documentIcon: Icons.business_outlined,
      documentColor: Colors.green,
    ),
  ),
  GoRoute(
    path: '/treasurer/community/documents/correction',
    name: 'treasurer-document-correction',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'correction',
      documentTitle: 'Permohonan Koreksi Data',
      documentIcon: Icons.edit_document,
      documentColor: Colors.purple,
    ),
  ),
  GoRoute(
    path: '/treasurer/community/documents/family',
    name: 'treasurer-document-family',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'family',
      documentTitle: 'Surat Keterangan Keluarga',
      documentIcon: Icons.family_restroom,
      documentColor: Colors.teal,
    ),
  ),
  GoRoute(
    path: '/treasurer/community/documents/other',
    name: 'treasurer-document-other',
    builder: (context, state) => const DocumentRequestFormScreen(
      documentType: 'other',
      documentTitle: 'Surat Lainnya',
      documentIcon: Icons.description_outlined,
      documentColor: Colors.grey,
    ),
  ),

  // Income feature
  GoRoute(
    path: '/treasurer/incomes',
    name: 'treasurer-incomes',
    builder: (context, state) => const PemasukanScreen(),
  ),

  // Expense
  GoRoute(
    path: '/treasurer/expenses',
    name: 'treasurer-expenses',
    builder: (context, state) => const PemasukanScreen(),
  ),

  // Transaction
  GoRoute(
    path: '/treasurer/transaction/history',
    name: 'treasurer-transaction-history',
    builder: (context, state) => const TransactionsPage(),
  ),

  // Dues
  GoRoute(
    path: '/treasurer/dues',
    name: 'treasurer-dues',
    builder: (context, state) => const DataIuranPage(),
  ),

  // Kategori
  GoRoute(
    path: '/treasurer/kategori',
    name: 'treasurer-kategori',
    builder: (context, state) => const KategoriScreen(),
  ),

  // Dues Detail
  GoRoute(
    path: '/treasurer/dues/detail',
    name: 'treasurer-dues-detail',
    builder: (context, state) {
      final item = state.extra as Map<String, String>;
      return DataIuranDetail(item: item);
    },
  ),

  // Transaction Detail
  GoRoute(
    path: '/treasurer/transaction/detail',
    name: 'treasurer-transaction-detail',
    builder: (context, state) {
      final item = state.extra as Map<String, dynamic>;
      return TransactionDetail(item: item);
    },
  ),
];
