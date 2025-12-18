import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/community_carousel.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/carousel_item.dart';
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
            // Welcome Card
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: WelcomeRoleCard(
                greeting: 'Selamat datang kembali!',
                role: 'Ketua RW 12',
                icon: Icons.star,
              ),
            ),
            const SizedBox(height: 20),

            // RW Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRwStats(context),
            ),
            const SizedBox(height: 24),

            // Community Updates Carousel
            CommunityCarousel(items: _getCarouselItems()),
            const SizedBox(height: 24),

            // Role Indicator - RW Functions
            _buildSectionHeader(
              context,
              'Fungsi Ketua RW',
              'Kelola koordinasi & supervisi RW',
              Icons.star,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getRwTabs(context),
              sectionTitle: 'Menu Ketua RW',
            ),
            const SizedBox(height: 32),

            // Role Indicator - Resident Functions
            _buildSectionHeader(
              context,
              'Layanan Warga',
              'Akses fitur sebagai warga',
              Icons.home,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getResidentTabs(context),
              sectionTitle: 'Menu Warga',
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _recentActivity(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRwStats(BuildContext context) {
    return Column(
      children: [
        // Main Stats Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ringkasan RW 12',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Januari 2024',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatsDetail(
                      'Total RT',
                      '10',
                      Icons.apartment_rounded,
                      Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatsDetail(
                      'Total Warga',
                      '1,245',
                      Icons.people_rounded,
                      Colors.lightGreenAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Rp 45.8 Jt',
                'Kas RW',
                Icons.account_balance_wallet_rounded,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '3',
                'Laporan',
                Icons.report_rounded,
                AppColors.error,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '5',
                'Rapat',
                Icons.event_rounded,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsDetail(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<CarouselItem> _getCarouselItems() {
    return [
      CarouselItem(
        title: '3 Laporan Perlu Ditindak',
        subtitle: 'Ada laporan dari warga yang memerlukan tindakan',
        icon: Icons.report_rounded,
        color: AppColors.error,
        type: 'announcement',
      ),
      CarouselItem(
        title: 'Rapat Koordinasi RW',
        subtitle: 'Sabtu, 27 Januari 2024 • 19:00 WIB',
        icon: Icons.meeting_room_rounded,
        color: AppColors.primary,
        type: 'event',
      ),
      CarouselItem(
        title: 'Gotong Royong RW',
        subtitle: 'Minggu, 28 Januari 2024 • 07:00 WIB',
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
    ];
  }

  List<TabData> _getRwTabs(BuildContext context) {
    return [
      TabData(
        label: 'Kelola RT',
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
            label: 'Data Warga RW',
            icon: Icons.people_rounded,
            onTap: () => context.push('/rw/data-warga'),
          ),
          MenuItem(
            label: 'Statistik RW',
            icon: Icons.insert_chart_rounded,
            onTap: () => context.push('/rw/statistics'),
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
            label: 'Rapat RW',
            icon: Icons.meeting_room_rounded,
            onTap: () => context.push('/rw/rapat'),
            badge: '1',
          ),
          MenuItem(
            label: 'Buat Pengumuman',
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
            label: 'Iuran RW',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/rw/iuran'),
          ),
          MenuItem(
            label: 'Ringkasan RT',
            icon: Icons.summarize_rounded,
            onTap: () => context.push('/rw/finance-summary'),
          ),
          MenuItem(
            label: 'Laporan Keuangan',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/rw/finance-report'),
          ),
          MenuItem(
            label: 'Transparansi Dana',
            icon: Icons.visibility_rounded,
            onTap: () => context.push('/rw/transparency'),
          ),
        ],
      ),
      TabData(
        label: 'Administrasi',
        icon: Icons.folder_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Kelola Laporan',
            icon: Icons.report_rounded,
            onTap: () => context.push('/rw/laporan'),
            badge: '3',
          ),
          MenuItem(
            label: 'Monitoring Wilayah',
            icon: Icons.my_location_rounded,
            onTap: () => context.push('/rw/monitoring'),
          ),
          MenuItem(
            label: 'Verifikasi Surat',
            icon: Icons.description_rounded,
            onTap: () => context.push('/rw/surat'),
          ),
          MenuItem(
            label: 'Arsip Dokumen',
            icon: Icons.archive_rounded,
            onTap: () => context.push('/rw/archive'),
          ),
        ],
      ),
    ];
  }

  List<TabData> _getResidentTabs(BuildContext context) {
    return [
      TabData(
        label: 'Data Pribadi',
        icon: Icons.person_rounded,
        items: [
          MenuItem(
            label: 'Info Kependudukan',
            icon: Icons.person_2_outlined,
            onTap: () => context.push('/resident/community/population'),
          ),
          MenuItem(
            label: 'Data Keluarga (KK)',
            icon: Icons.family_restroom,
            onTap: () => context.push('/resident/community/family'),
          ),
          MenuItem(
            label: 'Data Rumah',
            icon: Icons.home,
            onTap: () => context.push('/resident/community/home'),
          ),
        ],
      ),
      TabData(
        label: 'Iuran',
        icon: Icons.payments_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Bayar Iuran',
            icon: Icons.payment_rounded,
            onTap: () => context.push('/resident/community/dues'),
            badge: '1',
          ),
          MenuItem(
            label: 'Riwayat Pembayaran',
            icon: Icons.history_rounded,
            onTap: () => context.push('/resident/payment-history'),
          ),
          MenuItem(
            label: 'Kwitansi Digital',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/resident/digital-receipts'),
          ),
          MenuItem(
            label: 'Transparansi Keuangan',
            icon: Icons.trending_up,
            onTap: () =>
                context.push('/resident/community/finance-transparency'),
          ),
        ],
      ),
      TabData(
        label: 'Layanan',
        icon: Icons.description_rounded,
        items: [
          MenuItem(
            label: 'Ajukan Surat',
            icon: Icons.description_rounded,
            onTap: () => context.push('/resident/community/documents'),
          ),
          MenuItem(
            label: 'Lapor Masalah',
            icon: Icons.report_problem_rounded,
            onTap: () => context.push('/resident/report-issue'),
          ),
          MenuItem(
            label: 'Kirim Saran',
            icon: Icons.feedback_rounded,
            onTap: () => context.push('/resident/submit-suggestion'),
          ),
        ],
      ),
      TabData(
        label: 'Komunitas',
        icon: Icons.groups_rounded,
        items: [
          MenuItem(
            label: 'Pengumuman',
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/resident/announcements'),
          ),
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/resident/residents-directory'),
          ),
          MenuItem(
            label: 'Kontak Darurat',
            icon: Icons.contact_phone_rounded,
            onTap: () => context.push('/resident/emergency-contacts'),
          ),
        ],
      ),
    ];
  }

  Widget _recentActivity(BuildContext context) {
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
              onPressed: () => context.push('/rw/activity-log'),
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
        _buildActivityItem(
          'Laporan Kebersihan - RT 03',
          'Perlu Ditindaklanjuti',
          '2 jam yang lalu',
          Icons.report_rounded,
          AppColors.error,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Rapat Koordinasi RT',
          'Dijadwalkan',
          '5 jam yang lalu',
          Icons.event_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Iuran RW - RT 07',
          'Lunas',
          '1 hari yang lalu',
          Icons.payments_rounded,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String status,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
