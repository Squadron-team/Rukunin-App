import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/admin/admin_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/admin/admin_shell.dart';
import 'package:rukunin/pages/admin/warga/warga_list_page.dart';
import 'package:rukunin/pages/admin/warga/warga_detail_page.dart';
import 'package:rukunin/pages/admin/warga/warga_add_page.dart';
import 'package:rukunin/pages/admin/warga/warga_edit_page.dart';
import 'package:rukunin/pages/admin/iuran/keuangan_dashboard_page.dart';
import 'package:rukunin/pages/admin/iuran/iuran_list_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_list_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_detail_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_add_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_edit_page.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_list_page.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_edit_page.dart';
import 'package:rukunin/pages/admin/administrasi/role_management_page.dart';

final adminRoutes = ShellRoute(
  builder: (context, state, child) => AdminShell(child: child),
  routes: [
    GoRoute(
      path: '/admin',
      name: 'admin-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AdminHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/account',
      name: 'admin-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
    // Warga routes
    GoRoute(
      path: '/admin/warga',
      name: 'admin-warga',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: WargaListPage(),
      ),
    ),
    GoRoute(
      path: '/admin/warga/add',
      name: 'admin-warga-add',
      builder: (context, state) => const WargaAddPage(),
    ),
    GoRoute(
      path: '/admin/warga/detail',
      name: 'admin-warga-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return WargaDetailPage(
          name: extra['name'],
          nik: extra['nik'],
          alamat: extra['alamat'],
          noTelp: extra['noTelp'],
          status: extra['status'],
        );
      },
    ),
    GoRoute(
      path: '/admin/warga/edit',
      name: 'admin-warga-edit',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return WargaEditPage(
          name: extra['name'],
          alamat: extra['alamat'],
          status: extra['status'],
        );
      },
    ),
    // Keuangan routes
    GoRoute(
      path: '/admin/keuangan',
      name: 'admin-keuangan',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: KeuanganDashboardPage(),
      ),
    ),
    GoRoute(
      path: '/admin/keuangan/iuran',
      name: 'admin-iuran',
      builder: (context, state) => const IuranListPage(),
    ),
    // Marketplace routes
    GoRoute(
      path: '/admin/marketplace',
      name: 'admin-marketplace',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MarketplaceListPage(),
      ),
    ),
    GoRoute(
      path: '/admin/marketplace/add',
      name: 'admin-marketplace-add',
      builder: (context, state) => const MarketplaceAddPage(),
    ),
    GoRoute(
      path: '/admin/marketplace/detail',
      name: 'admin-marketplace-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MarketplaceDetailPage(
          id: extra['id'],
          name: extra['name'],
          seller: extra['seller'],
          phone: extra['phone'],
          price: extra['price'],
          category: extra['category'],
          image: extra['image'],
          stock: extra['stock'],
          isActive: extra['isActive'],
          description: extra['description'],
        );
      },
    ),
    GoRoute(
      path: '/admin/marketplace/edit',
      name: 'admin-marketplace-edit',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MarketplaceEditPage(
          id: extra['id'],
          name: extra['name'],
          seller: extra['seller'],
          phone: extra['phone'],
          price: extra['price'],
          category: extra['category'],
          image: extra['image'],
          stock: extra['stock'],
          isActive: extra['isActive'],
          description: extra['description'],
        );
      },
    ),
    // Administrasi routes
    GoRoute(
      path: '/admin/akun',
      name: 'admin-akun',
      builder: (context, state) => const AkunAdminListPage(),
    ),
    GoRoute(
      path: '/admin/akun/edit',
      name: 'admin-akun-edit',
      builder: (context, state) {
        final adminId = state.uri.queryParameters['id'];
        return AkunAdminEditPage(adminId: adminId);
      },
    ),
    GoRoute(
      path: '/admin/role',
      name: 'admin-role',
      builder: (context, state) => const RoleManagementPage(),
    ),
  ],
);
