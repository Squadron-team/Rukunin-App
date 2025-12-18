import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/community_carousel.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/carousel_item.dart';
import 'package:rukunin/models/menu_item.dart';

class SecretaryHomeScreen extends StatelessWidget {
  const SecretaryHomeScreen({super.key});

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
                role: 'Sekretaris RT 05 / RW 12',
                icon: Icons.work_outline,
              ),
            ),
            const SizedBox(height: 20),

            // Secretary Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSecretaryStats(context),
            ),
            const SizedBox(height: 24),

            // Community Updates Carousel
            CommunityCarousel(items: _getCarouselItems()),
            const SizedBox(height: 24),

            // Role Indicator - Secretary Functions
            _buildSectionHeader(
              context,
              'Fungsi Sekretaris',
              'Kelola administrasi & dokumentasi',
              Icons.work_outline,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getSecretaryTabs(context),
              sectionTitle: 'Menu Sekretaris',
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

  Widget _buildSecretaryStats(BuildContext context) {
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
                    'Administrasi & Surat',
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
                      'Surat Masuk',
                      '8',
                      Icons.mail_rounded,
                      Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatsDetail(
                      'Surat Selesai',
                      '12',
                      Icons.check_circle,
                      Colors.greenAccent,
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
                '8',
                'Pending',
                Icons.pending_actions_rounded,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '3',
                'Rapat',
                Icons.event_rounded,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '45',
                'Dokumen',
                Icons.folder_rounded,
                Colors.purple,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<CarouselItem> _getCarouselItems() {
    return [
      CarouselItem(
        title: '5 Surat Perlu Diproses',
        subtitle: 'Ada permohonan surat yang perlu ditindaklanjuti',
        icon: Icons.mail_rounded,
        color: AppColors.warning,
        type: 'announcement',
      ),
      CarouselItem(
        title: 'Rapat Koordinasi Minggu Ini',
        subtitle: 'Jumat, 26 Januari 2024 • 19:00 WIB',
        icon: Icons.event_rounded,
        color: AppColors.primary,
        type: 'event',
      ),
      CarouselItem(
        title: 'Kerja Bakti Minggu Depan',
        subtitle: 'Minggu, 21 Januari 2024 • 07:00 WIB',
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
    ];
  }

  List<TabData> _getSecretaryTabs(BuildContext context) {
    return [
      TabData(
        label: 'Surat',
        icon: Icons.description_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Buat Surat',
            icon: Icons.edit_document,
            onTap: () => context.push('/secretary/create-letter'),
          ),
          MenuItem(
            label: 'Surat Masuk',
            icon: Icons.mail_rounded,
            onTap: () => context.push('/secretary/incoming-mail'),
            badge: '5',
          ),
          MenuItem(
            label: 'Surat Keluar',
            icon: Icons.send_rounded,
            onTap: () => context.push('/secretary/outgoing-mail'),
          ),
          MenuItem(
            label: 'Template Surat',
            icon: Icons.article_rounded,
            onTap: () => context.push('/secretary/letter-templates'),
          ),
        ],
      ),
      TabData(
        label: 'Rapat',
        icon: Icons.event_note_rounded,
        items: [
          MenuItem(
            label: 'Jadwal Rapat',
            icon: Icons.calendar_today_rounded,
            onTap: () => context.push('/secretary/meeting-schedule'),
          ),
          MenuItem(
            label: 'Notulensi',
            icon: Icons.record_voice_over_rounded,
            onTap: () => context.push('/secretary/minutes'),
          ),
          MenuItem(
            label: 'Undangan Rapat',
            icon: Icons.mail_outline_rounded,
            onTap: () => context.push('/secretary/meeting-invitations'),
          ),
        ],
      ),
      TabData(
        label: 'Administrasi',
        icon: Icons.folder_rounded,
        items: [
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/secretary/residents-data'),
          ),
          MenuItem(
            label: 'Arsip Dokumen',
            icon: Icons.folder_shared_rounded,
            onTap: () => context.push('/secretary/archive'),
          ),
          MenuItem(
            label: 'Laporan Bulanan',
            icon: Icons.assessment_rounded,
            onTap: () => context.push('/secretary/monthly-reports'),
          ),
          MenuItem(
            label: 'Riwayat Surat',
            icon: Icons.history_rounded,
            onTap: () => context.push('/secretary/letter-history'),
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
              onPressed: () => context.push('/secretary/letter-history'),
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
          'Surat Domisili - Ibu Sari',
          'Disetujui',
          '5 menit yang lalu',
          Icons.check_circle_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Permohonan Surat - Pak Joko',
          'Menunggu Verifikasi',
          '30 menit yang lalu',
          Icons.pending_rounded,
          AppColors.warning,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Rapat Koordinasi RT',
          'Dijadwalkan',
          '1 jam yang lalu',
          Icons.event_rounded,
          Colors.blue,
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
