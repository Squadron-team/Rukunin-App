import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/menu_card.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeRoleCard(
                greeting: 'Selamat datang kembali!',
                role: 'Admin RW 05',
                icon: Icons.admin_panel_settings,
              ),
              const SizedBox(height: 24),
              _buildStatisticsSection(),
              const SizedBox(height: 32),
              _buildMenuSection(context),
              const SizedBox(height: 32),
              _buildActivitySection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Sistem',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
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
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.event,
                label: 'Kegiatan Aktif',
                value: '8',
                color: AppColors.success,
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
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.payments,
                label: 'Iuran Tertunda',
                value: '45',
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            MenuCard(
              icon: Icons.manage_accounts,
              label: 'Kelola Akun',
              onTap: () => context.push('/admin/akun'),
            ),
            MenuCard(
              icon: Icons.settings,
              label: 'Role Akun',
              onTap: () => context.push('/admin/role'),
            ),
            MenuCard(
              icon: Icons.group,
              label: 'Data Warga',
              onTap: () => context.push('/admin/warga'),
            ),
            MenuCard(
              icon: Icons.campaign,
              label: 'Pengumuman',
              onTap: () => context.push('/admin/pengumuman'),
            ),
            MenuCard(
              icon: Icons.event_note,
              label: 'Kegiatan',
              onTap: () => context.push('/admin/kegiatan'),
            ),
            MenuCard(
              icon: Icons.assignment,
              label: 'Laporan',
              onTap: () => context.push('/admin/laporan'),
            ),
            MenuCard(
              icon: Icons.account_balance_wallet,
              label: 'Iuran',
              onTap: () => context.push('/admin/keuangan'),
            ),
            MenuCard(
              icon: Icons.verified_user,
              label: 'Verifikasi',
              onTap: () => context.push('/admin/verifikasi'),
            ),
            MenuCard(
              icon: Icons.analytics,
              label: 'Analitik',
              onTap: () => context.push('/admin/analytics'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.person_add,
          title: 'Warga Baru Terdaftar',
          subtitle: 'Budi Santoso telah terdaftar sebagai warga baru',
          time: '5 menit yang lalu',
          color: AppColors.success,
        ),
        _buildActivityItem(
          icon: Icons.report,
          title: 'Laporan Baru',
          subtitle: 'Laporan kerusakan jalan di Gang 5',
          time: '15 menit yang lalu',
          color: AppColors.warning,
        ),
        _buildActivityItem(
          icon: Icons.payments,
          title: 'Pembayaran Iuran',
          subtitle: 'Ibu Siti telah membayar iuran bulan November',
          time: '1 jam yang lalu',
          color: AppColors.info,
        ),
        _buildActivityItem(
          icon: Icons.event,
          title: 'Kegiatan Baru',
          subtitle: 'Kerja bakti dijadwalkan minggu depan',
          time: '2 jam yang lalu',
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
