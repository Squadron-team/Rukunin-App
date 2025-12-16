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
import 'package:rukunin/pages/admin/iuran/iuran_payment_page.dart';
import 'package:rukunin/pages/admin/iuran/catat_pembayaran_page.dart';
import 'package:rukunin/pages/admin/marketplace/admin_marketplace_screen.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_detail_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_add_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_edit_page.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_list_page.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_edit_page.dart';
import 'package:rukunin/pages/admin/administrasi/role_management_page.dart';
import 'package:rukunin/pages/admin/activities/admin_activities_screen.dart';
import 'package:rukunin/pages/admin/activities/admin_activity_detail_screen.dart';
import 'package:rukunin/pages/admin/laporan/laporan_list_page.dart';
import 'package:rukunin/pages/admin/laporan/laporan_detail_page.dart';
import 'package:rukunin/pages/admin/laporan/laporan_add_page.dart';
import 'package:rukunin/pages/admin/pengumuman/pengumuman_add_page.dart';
import 'package:rukunin/pages/admin/pengumuman/pengumuman_detail_page.dart';
import 'package:rukunin/pages/admin/pengumuman/pengumuman_list_page.dart';
import 'package:rukunin/pages/admin/kegiatan_warga/kegiatan_list_page.dart';
import 'package:rukunin/pages/admin/kegiatan_warga/kegiatan_add_page.dart';
import 'package:rukunin/pages/admin/kegiatan_warga/kegiatan_detail_page.dart';
import 'package:rukunin/pages/admin/verifikasi/verifikasi_detail_page.dart';
import 'package:rukunin/pages/admin/verifikasi/verifikasi_list_page.dart';
import 'package:rukunin/pages/admin/analitik/analytics_screen.dart';
import 'package:rukunin/pages/admin/permintaan_akun/permintaan_akun_detail_page.dart';
import 'package:rukunin/pages/admin/permintaan_akun/permintaan_akun_list_page.dart';

final adminRoutes = [
  // =====================================================================
  // Main routes with bottom navigation
  // =====================================================================
  ShellRoute(
    builder: (context, state, child) => AdminShell(child: child),
    routes: [
      GoRoute(
        path: '/admin',
        name: 'admin-home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AdminHomeScreen()),
      ),
      GoRoute(
        path: '/admin/marketplace',
        name: 'admin-marketplace',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AdminMarketplaceScreen()),
      ),
      GoRoute(
        path: '/admin/activities',
        name: 'admin-activities',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AdminActivitiesScreen()),
      ),
      GoRoute(
        path: '/admin/account',
        name: 'admin-account',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountScreen()),
      ),
    ],
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - WARGA
  // =====================================================================
  GoRoute(
    path: '/admin/warga',
    name: 'admin-warga',
    builder: (context, state) => const WargaListPage(),
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

  // =====================================================================
  // Deep-link routes without bottom navigation - KEUANGAN & IURAN
  // =====================================================================
  GoRoute(
    path: '/admin/keuangan',
    name: 'admin-keuangan',
    builder: (context, state) => const KeuanganDashboardPage(),
  ),
  GoRoute(
    path: '/admin/keuangan/iuran',
    name: 'admin-iuran',
    builder: (context, state) => const IuranListPage(),
  ),
  GoRoute(
    path: '/admin/iuran/payment',
    name: 'admin-iuran-payment',
    builder: (context, state) {
      final data = state.extra as Map;
      return IuranPaymentPage(
        name: data['name'],
        period: data['period'],
        amount: data['amount'],
      );
    },
  ),
  GoRoute(
    path: '/admin/keuangan/catat-pembayaran',
    name: 'admin-catat-pembayaran',
    builder: (context, state) => const CatatPembayaranPage(),
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - MARKETPLACE
  // =====================================================================
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

  // =====================================================================
  // Deep-link routes without bottom navigation - ADMINISTRASI
  // =====================================================================
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

  // =====================================================================
  // Deep-link routes without bottom navigation - PENGUMUMAN
  // =====================================================================
  GoRoute(
    path: '/admin/pengumuman',
    name: 'admin-pengumuman',
    builder: (context, state) => const PengumumanListPage(),
  ),
  GoRoute(
    path: '/admin/pengumuman/detail',
    name: 'admin-pengumuman-detail',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      return PengumumanDetailPage(
        judul: data['judul'],
        tanggal: data['tanggal'],
        ringkasan: data['ringkasan'],
      );
    },
  ),
  GoRoute(
    path: '/admin/pengumuman/add',
    name: 'admin-pengumuman-add',
    builder: (context, state) => const PengumumanAddPage(),
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - LAPORAN
  // =====================================================================
  GoRoute(
    path: '/admin/laporan',
    name: 'admin-laporan',
    builder: (context, state) => const LaporanListPage(),
  ),
  GoRoute(
    path: '/admin/laporan/detail',
    name: 'admin-laporan-detail',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>?;
      return LaporanDetailPage(
        judul: data?['judul'] ?? '',
        kategori: data?['kategori'] ?? '',
        tanggal: data?['tanggal'] ?? '',
        status: data?['status'] ?? '',
      );
    },
  ),
  GoRoute(
    path: '/admin/laporan/add',
    name: 'admin-laporan-add',
    builder: (context, state) => const LaporanAddPage(),
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - KEGIATAN WARGA
  // =====================================================================
  GoRoute(
    path: '/admin/kegiatan',
    name: 'admin-kegiatan',
    builder: (context, state) => const KegiatanListPage(),
  ),
  GoRoute(
    path: '/admin/kegiatan/add',
    name: 'admin-kegiatan-add',
    builder: (context, state) => const KegiatanAddPage(),
  ),
  GoRoute(
    path: '/admin/kegiatan/detail',
    name: 'admin-kegiatan-detail',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      return KegiatanDetailPage(
        judul: data['judul'] ?? 'Tidak ada judul',
        tanggal: data['tanggal'] ?? '-',
        lokasi: data['lokasi'] ?? 'Lokasi tidak tersedia',
        deskripsi: data['deskripsi'] ?? 'Tidak ada deskripsi',
      );
    },
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - VERIFIKASI & ANALITIK
  // =====================================================================
  GoRoute(
    path: '/admin/verifikasi',
    name: 'admin-verifikasi',
    builder: (context, state) => const VerifikasiListPage(),
  ),
  GoRoute(
    path: '/admin/verifikasi/detail',
    name: 'admin-verifikasi-detail',
    builder: (context, state) {
      final data = state.extra as Map;
      return VerifikasiDetailPage(
        name: data['name'],
        nik: data['nik'],
        alamat: data['alamat'],
        foto: data['foto'],
      );
    },
  ),
  GoRoute(
    path: '/admin/analytics',
    name: 'admin-analytics',
    builder: (context, state) => const AnalyticsScreen(),
  ),

  // Di dalam routes list GoRouter Anda
  GoRoute(
    path: '/admin/account-requests',
    name: 'admin-account-requests',
    builder: (context, state) {
      return const PermintaanAkunListPage();
    },
  ),

  GoRoute(
    path: '/admin/permintaan-akun/detail',
    name: 'admin-permintaan-akun-detail',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      return PermintaanAkunDetailPage(
        name: data['name'] as String,
        nik: data['nik'] as String,
        email: data['email'] as String,
        phone: data['phone'] as String,
        alamat: data['alamat'] as String,
        foto: data['foto'] as String,
        tanggal: data['tanggal'] as String,
      );
    },
  ),

  // =====================================================================
  // Deep-link routes without bottom navigation - ACTIVITIES DETAIL
  // =====================================================================
  GoRoute(
    path: '/admin/activities/detail',
    name: 'admin-activity-detail',
    builder: (context, state) {
      final activity = state.extra as Map<String, dynamic>;
      return AdminActivityDetailScreen(activity: activity);
    },
  ),
];
