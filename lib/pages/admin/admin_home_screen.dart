import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/menu_item.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const WelcomeRoleCard(
                    greeting: 'Selamat datang kembali!',
                    role: 'Admin RW 05',
                    icon: Icons.admin_panel_settings,
                  ),
                  const SizedBox(height: 20),
                  _compactStats(context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MenuTabsSection(tabs: _getMenuTabs(context)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _recentActivity(),
            ),
          ],
        ),
      ),
    );
  }

  List<TabData> _getMenuTabs(BuildContext context) {
    return [
      TabData(
        label: 'Administrasi',
        icon: Icons.manage_accounts_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Kelola Akun',
            icon: Icons.manage_accounts_rounded,
            onTap: () => context.push('/admin/akun'),
          ),
          MenuItem(
            label: 'Role & Permissions',
            icon: Icons.verified_user_rounded,
            onTap: () => context.push('/admin/role'),
          ),
          MenuItem(
            label: 'Permintaan Akun',
            icon: Icons.person_add_rounded,
            onTap: () => context.push('/admin/account-requests'),
            badge: '5',
          ),
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/admin/warga'),
          ),
          MenuItem(
            label: 'Verifikasi Data',
            icon: Icons.fact_check_rounded,
            onTap: () => context.push('/admin/verifikasi'),
          ),
        ],
      ),
      TabData(
        label: 'Keuangan',
        icon: Icons.account_balance_rounded,
        items: [
          MenuItem(
            label: 'Laporan RT/RW',
            icon: Icons.assessment_rounded,
            onTap: () => context.push('/admin/financial-reports'),
          ),
          MenuItem(
            label: 'Persetujuan Bendahara',
            icon: Icons.approval_rounded,
            onTap: () => context.push('/admin/treasurer-approvals'),
          ),
          MenuItem(
            label: 'Anggaran Tahunan',
            icon: Icons.calendar_view_month_rounded,
            onTap: () => context.push('/admin/annual-budget'),
          ),
          MenuItem(
            label: 'Monitor Iuran',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/admin/keuangan'),
          ),
        ],
      ),
      TabData(
        label: 'Komunitas',
        icon: Icons.groups_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Persetujuan Pengumuman',
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/admin/pengumuman'),
            badge: '3',
          ),
          MenuItem(
            label: 'Persetujuan Kegiatan',
            icon: Icons.event_rounded,
            onTap: () => context.push('/admin/kegiatan'),
            badge: '2',
          ),
          MenuItem(
            label: 'Kelola Laporan',
            icon: Icons.report_rounded,
            onTap: () => context.push('/admin/laporan'),
          ),
          MenuItem(
            label: 'Peraturan Desa',
            icon: Icons.gavel_rounded,
            onTap: () => context.push('/admin/village-rules'),
          ),
        ],
      ),
      TabData(
        label: 'Sistem',
        icon: Icons.settings_rounded,
        items: [
          MenuItem(
            label: 'Pengaturan Sistem',
            icon: Icons.settings_rounded,
            onTap: () => context.push('/admin/system-settings'),
          ),
          MenuItem(
            label: 'Analitik',
            icon: Icons.analytics_rounded,
            onTap: () => context.push('/admin/analytics'),
          ),
          MenuItem(
            label: 'Log Aktivitas',
            icon: Icons.history_rounded,
            onTap: () => context.push('/admin/activity-logs'),
          ),
          MenuItem(
            label: 'Backup Data',
            icon: Icons.backup_rounded,
            onTap: () => context.push('/admin/backup'),
          ),
        ],
      ),
    ];
  }

  Widget _compactStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _compactStatCard(
            '1,234',
            'Warga',
            Icons.people_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '12',
            'Pending',
            Icons.pending_actions_rounded,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '8',
            'Kegiatan',
            Icons.event_rounded,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _compactStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _compactActivityItem(
          'Warga baru: Budi Santoso terdaftar',
          '5 menit',
          Icons.person_add_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Laporan baru: Kerusakan jalan Gang 5',
          '15 menit',
          Icons.report_rounded,
          AppColors.warning,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Kegiatan baru menunggu persetujuan',
          '1 jam',
          Icons.event_rounded,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _compactActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
