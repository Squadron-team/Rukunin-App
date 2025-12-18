import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/menu_item.dart';

class RtHomeScreen extends StatelessWidget {
  const RtHomeScreen({super.key});

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
                    role: 'Ketua RT 03',
                    icon: Icons.home,
                  ),
                  const SizedBox(height: 20),
                  _compactStats(context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MenuTabsSection(
              tabs: _getMenuTabs(context),
              sectionTitle: 'Menu Ketua RT',
            ),
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
        label: 'Warga',
        icon: Icons.people_rounded,
        items: [
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/rt/warga/list'),
          ),
          MenuItem(
            label: 'Tambah Warga',
            icon: Icons.person_add_rounded,
            onTap: () => context.push('/rt/tambah-warga'),
          ),
          MenuItem(
            label: 'Data Keluarga',
            icon: Icons.badge_rounded,
            onTap: () => context.push('/rt/warga/family'),
          ),
          MenuItem(
            label: 'Wilayah RT',
            icon: Icons.map,
            onTap: () => context.push('/rt/wilayah'),
          ),
          MenuItem(
            label: 'Catat Mutasi',
            icon: Icons.swap_horiz,
            onTap: () => context.push('/rt/mutasi'),
          ),
        ],
      ),
      TabData(
        label: 'Keuangan',
        icon: Icons.account_balance_wallet_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Iuran Bulanan',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/rt/iuran'),
            badge: '7',
          ),
          MenuItem(
            label: 'Kas RT',
            icon: Icons.account_balance_rounded,
            onTap: () => context.push('/rt/kas'),
          ),
          MenuItem(
            label: 'Riwayat Transaksi',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/rt/transaksi'),
          ),
        ],
      ),
      TabData(
        label: 'Kegiatan',
        icon: Icons.event_rounded,
        items: [
          MenuItem(
            label: 'Kegiatan RT',
            icon: Icons.event_rounded,
            onTap: () => context.push('/rt/activity'),
          ),
          MenuItem(
            label: 'Rapat RT',
            icon: Icons.meeting_room_rounded,
            onTap: () => context.push('/rt/meetings'),
          ),
          MenuItem(
            label: 'Pengumuman',
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/rt/announcements'),
          ),
        ],
      ),
      TabData(
        label: 'Layanan',
        icon: Icons.assignment_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Pengajuan Surat',
            icon: Icons.description_rounded,
            onTap: () => context.push('/rt/surat/pengajuan'),
            badge: '2',
          ),
          MenuItem(
            label: 'Laporan Warga',
            icon: Icons.report_rounded,
            onTap: () => context.push('/rt/reports/manage'),
            badge: '3',
          ),
          MenuItem(
            label: 'Bantuan Sosial',
            icon: Icons.volunteer_activism_rounded,
            onTap: () => context.push('/rt/bansos'),
          ),
          MenuItem(
            label: 'Laporan RT',
            icon: Icons.insert_chart,
            onTap: () => context.push('/rt/reports/statistic'),
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
            '45',
            'Warga',
            Icons.people_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '38/45',
            'Iuran',
            Icons.payments_rounded,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '3',
            'Laporan',
            Icons.report_rounded,
            AppColors.warning,
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
          'Pembayaran iuran dari Pak Budi',
          '5 menit',
          Icons.payments_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Pengajuan surat dari Ibu Siti',
          '30 menit',
          Icons.description_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Laporan lampu jalan mati',
          '1 jam',
          Icons.report_rounded,
          AppColors.warning,
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
