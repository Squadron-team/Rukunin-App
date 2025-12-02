import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/menu_card.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class RwHomeScreen extends StatelessWidget {
  const RwHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalWarga = 248;
    const totalKeuangan = 'Rp 45.8 Jt';

    return Scaffold(
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const WelcomeRoleCard(
                greeting: 'Selamat datang kembali!',
                role: 'Ketua RW 05',
                icon: Icons.star,
              ),
              const SizedBox(height: 28),
              _quickStats(context),
              const SizedBox(height: 28),
              _insightSection(context, totalWarga, totalKeuangan),
              const SizedBox(height: 28),
              _menuSection(context),
              const SizedBox(height: 28),
              _recentActivity(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _quickStatCard(
            'Laporan Baru',
            '3',
            Icons.report_problem_rounded,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickStatCard(
            'Pengumuman',
            '5',
            Icons.campaign_rounded,
            AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickStatCard(
            'Rapat Hari Ini',
            '1',
            Icons.event_rounded,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _quickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
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

  Widget _insightSection(
    BuildContext context,
    int totalWarga,
    String totalKeuangan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Utama',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _insightCard(
          context: context,
          title: 'Total RT',
          value: '12 RT',
          subtitle: 'Di wilayah RW 05',
          icon: Icons.home_work_rounded,
          color: AppColors.primary,
          trend: '+2 RT baru',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _insightCard(
                context: context,
                title: 'Jumlah Warga',
                value: totalWarga.toString(),
                subtitle: 'Terdaftar aktif',
                icon: Icons.people_rounded,
                color: AppColors.primary,
                route: '/rw/data-warga',
                trend: '+12 bulan ini',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _insightCard(
                context: context,
                title: 'Total Keuangan',
                value: totalKeuangan,
                subtitle: 'Saldo tersedia',
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.success,
                route: '/rw/iuran',
                trend: '+8.5% bulan ini',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _insightCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? trend,
    String? route,
  }) {
    final bool clickable = route != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: clickable ? () => context.push(route) : null,
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (clickable)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              if (trend != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Layanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            MenuCard(
              icon: Icons.people_rounded,
              label: 'Data Warga',
              onTap: () => context.push('/rw/data-warga'),
            ),
            MenuCard(
              icon: Icons.payments_rounded,
              label: 'Iuran',
              onTap: () => context.push('/rw/iuran'),
            ),
            MenuCard(
              icon: Icons.event_rounded,
              label: 'Kegiatan',
              onTap: () => context.push('/rw/kegiatan'),
            ),
            MenuCard(
              icon: Icons.receipt_long_rounded,
              label: 'Laporan',
              onTap: () => context.push('/rw/laporan'),
            ),
            MenuCard(
              icon: Icons.campaign_rounded,
              label: 'Pengumuman',
              onTap: () => context.push('/rw/pengumuman'),
            ),
            MenuCard(
              icon: Icons.meeting_room_rounded,
              label: 'Rapat',
              onTap: () => context.push('/rw/rapat'),
            ),
            MenuCard(
              icon: Icons.description_rounded,
              label: 'Surat',
              onTap: () => context.push('/rw/surat'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recentActivity() {
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
        _activityItem(
          'Laporan kebersihan diterima',
          '2 jam yang lalu',
          Icons.report_rounded,
          AppColors.warning,
        ),
        const SizedBox(height: 12),
        _activityItem(
          'Rapat RT 03 dijadwalkan',
          '5 jam yang lalu',
          Icons.event_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 12),
        _activityItem(
          'Iuran Agustus - 85% terkumpul',
          '1 hari yang lalu',
          Icons.payments_rounded,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _activityItem(String title, String time, IconData icon, Color color) {
    return Container(
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
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
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
