import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/pages/admin/administrasi/role_management_page.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_list_page.dart';
import 'package:rukunin/pages/admin/warga/warga_list_page.dart';
import 'package:rukunin/pages/admin/iuran/keuangan_dashboard_page.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_list_page.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Dashboard Admin',
      currentIndex: 0,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card -------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang kembali!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Super Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistik -----------------------------------------------------------
              const Text(
                'Statistik Sistem',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people,
                      label: 'Total Warga',
                      value: '1,234',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.event,
                      label: 'Kegiatan Aktif',
                      value: '8',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.report_problem,
                      label: 'Laporan Pending',
                      value: '12',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.payment,
                      label: 'Iuran Tertunda',
                      value: '45',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Menu Admin ---------------------------------------------------------
              const Text(
                'Menu Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.80,
                children: [
                  QuickAccessItem(
                    icon: Icons.manage_accounts,
                    label: 'Kelola Akun',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AkunAdminListPage(),
                        ),
                      );
                    },
                  ),
                                    QuickAccessItem(
                    icon: Icons.settings,
                    label: 'Manajemen Role Akun',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoleManagementPage(),
                        ),
                      );
                    },
                  ),
                  QuickAccessItem(
                    icon: Icons.group,
                    label: 'Data Warga',
                    color: AppColors.primary, 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WargaListPage(),
                        ),
                      );
                    },
                  ),
                  QuickAccessItem(
                    icon: Icons.article,
                    label: 'Pengumuman',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  QuickAccessItem(
                    icon: Icons.event_note,
                    label: 'Kegiatan',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  QuickAccessItem(
                    icon: Icons.assignment,
                    label: 'Laporan',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  QuickAccessItem(
                    icon: Icons.account_balance_wallet,
                    label: 'Iuran',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KeuanganDashboardPage(),
                        ),
                      );
                    },
                  ),
                  QuickAccessItem(
                    icon: Icons.store,
                    label: 'Marketplace',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MarketplaceListPage(),
                        ),
                      );
                    },
                  ),
                  QuickAccessItem(
                    icon: Icons.verified_user,
                    label: 'Verifikasi',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  QuickAccessItem(
                    icon: Icons.analytics,
                    label: 'Analitik',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Aktifitas ----------------------------------------------------------
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              _buildActivityItem(
                context,
                icon: Icons.person_add,
                title: 'Warga Baru Terdaftar',
                subtitle: 'Budi Santoso telah terdaftar sebagai warga baru',
                time: '5 menit yang lalu',
                color: Colors.green,
              ),
              _buildActivityItem(
                context,
                icon: Icons.report,
                title: 'Laporan Baru',
                subtitle: 'Laporan kerusakan jalan di Gang 5',
                time: '15 menit yang lalu',
                color: Colors.orange,
              ),
              _buildActivityItem(
                context,
                icon: Icons.payment,
                title: 'Pembayaran Iuran',
                subtitle: 'Ibu Siti telah membayar iuran bulan November',
                time: '1 jam yang lalu',
                color: Colors.blue,
              ),
              _buildActivityItem(
                context,
                icon: Icons.event,
                title: 'Kegiatan Baru',
                subtitle: 'Kerja bakti dijadwalkan minggu depan',
                time: '2 jam yang lalu',
                color: Colors.purple,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // CARD Statistik -----------------------------------------------------------
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // CARD Aktivitas -----------------------------------------------------------
  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Navigate ke detail activity jika diperlukan
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}