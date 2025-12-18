import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/menu_item.dart';

class RwHomeScreen extends StatelessWidget {
  const RwHomeScreen({super.key});

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
                    role: 'Ketua RW 05',
                    icon: Icons.star,
                  ),
                  const SizedBox(height: 20),
                  _compactStats(context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MenuTabsSection(
              tabs: _getMenuTabs(context),
              sectionTitle: 'Menu Ketua RW',
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
        label: 'RT',
        icon: Icons.apartment_rounded,
        items: [
          MenuItem(
            label: 'Daftar RT',
            icon: Icons.view_list_rounded,
            onTap: () => context.push('/rw/rt-list'),
          ),
          MenuItem(
            label: 'Kinerja RT',
            icon: Icons.analytics_rounded,
            onTap: () => context.push('/rw/rt-performance'),
          ),
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/rw/data-warga'),
          ),
        ],
      ),
      TabData(
        label: 'Kegiatan',
        icon: Icons.event_note_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Kegiatan RW',
            icon: Icons.event_rounded,
            onTap: () => context.push('/rw/kegiatan'),
            badge: '2',
          ),
          MenuItem(
            label: 'Rapat',
            icon: Icons.meeting_room_rounded,
            onTap: () => context.push('/rw/rapat'),
            badge: '1',
          ),
          MenuItem(
            label: 'Pengumuman',
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/rw/pengumuman'),
          ),
        ],
      ),
      TabData(
        label: 'Keuangan',
        icon: Icons.account_balance_rounded,
        items: [
          MenuItem(
            label: 'Iuran Warga',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/rw/iuran'),
          ),
          MenuItem(
            label: 'Ringkasan RT',
            icon: Icons.summarize_rounded,
            onTap: () => context.push('/rw/finance-summary'),
          ),
          MenuItem(
            label: 'Laporan',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/rw/finance-report'),
          ),
        ],
      ),
      TabData(
        label: 'Keamanan',
        icon: Icons.security_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Laporan',
            icon: Icons.report_rounded,
            onTap: () => context.push('/rw/laporan'),
            badge: '3',
          ),
          MenuItem(
            label: 'Monitoring',
            icon: Icons.my_location_rounded,
            onTap: () => context.push('/rw/monitoring'),
          ),
          MenuItem(
            label: 'Surat',
            icon: Icons.description_rounded,
            onTap: () => context.push('/rw/surat'),
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
            '12 RT',
            'Total RT',
            Icons.apartment_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '248',
            'Warga',
            Icons.people_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            'Rp 45.8 Jt',
            'Keuangan',
            Icons.account_balance_wallet_rounded,
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
          'Laporan kebersihan diterima',
          '2 jam',
          Icons.report_rounded,
          AppColors.warning,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Rapat RT 03 dijadwalkan',
          '5 jam',
          Icons.event_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Iuran Agustus - 85% terkumpul',
          '1 hari',
          Icons.payments_rounded,
          AppColors.success,
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
