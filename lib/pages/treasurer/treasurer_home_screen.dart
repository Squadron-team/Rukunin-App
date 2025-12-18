import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/community_carousel.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/carousel_item.dart';
import 'package:rukunin/models/menu_item.dart';

class TreasurerHomeScreen extends StatelessWidget {
  const TreasurerHomeScreen({super.key});

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
                role: 'Bendahara RT 05 / RW 12',
                icon: Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(height: 20),

            // Financial Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFinancialStats(context),
            ),
            const SizedBox(height: 24),

            // Community Updates Carousel
            CommunityCarousel(items: _getCarouselItems()),
            const SizedBox(height: 24),

            // Role Indicator - Treasurer Functions
            _buildSectionHeader(
              context,
              'Fungsi Bendahara',
              'Kelola keuangan RT/RW',
              Icons.account_balance_wallet,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getTreasurerTabs(context),
              sectionTitle: 'Menu Bendahara',
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
              child: _buildRecentActivity(context),
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

  Widget _buildFinancialStats(BuildContext context) {
    return Column(
      children: [
        // Main Balance Card
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
                    'Saldo Kas RT/RW',
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
              const SizedBox(height: 8),
              const Text(
                'Rp 45.750.000',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceDetail(
                      'Pemasukan',
                      'Rp 25.5 Jt',
                      Icons.arrow_downward,
                      Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBalanceDetail(
                      'Pengeluaran',
                      'Rp 12.3 Jt',
                      Icons.arrow_upward,
                      Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Stats Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '8/10 RT',
                'Sudah Bayar',
                Icons.check_circle_rounded,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '2 RT',
                'Belum Bayar',
                Icons.pending_rounded,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '145',
                'Transaksi',
                Icons.receipt_long_rounded,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceDetail(
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
                    fontSize: 14,
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
        title: 'Batas Pembayaran Iuran',
        subtitle: 'Tenggat pembayaran: 25 Januari 2024',
        icon: Icons.payments_rounded,
        color: AppColors.error,
        type: 'payment',
      ),
      CarouselItem(
        title: 'Kerja Bakti Minggu Ini',
        subtitle: 'Minggu, 21 Januari 2024 • 07:00 WIB',
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
      CarouselItem(
        title: 'Perubahan Jadwal Ronda',
        subtitle: 'Jadwal ronda malam telah diperbarui',
        icon: Icons.campaign_rounded,
        color: AppColors.warning,
        type: 'announcement',
      ),
    ];
  }

  List<TabData> _getTreasurerTabs(BuildContext context) {
    return [
      TabData(
        label: 'Iuran',
        icon: Icons.payments_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Kelola Iuran',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/treasurer/dues'),
            badge: '2',
          ),
          MenuItem(
            label: 'Buat Kwitansi',
            icon: Icons.receipt_rounded,
            onTap: () => context.push('/treasurer/create-receipt'),
          ),
          MenuItem(
            label: 'Tagihan Tertunda',
            icon: Icons.pending_actions_rounded,
            onTap: () => context.push('/treasurer/pending-bills'),
          ),
        ],
      ),
      TabData(
        label: 'Transaksi',
        icon: Icons.receipt_long_rounded,
        items: [
          MenuItem(
            label: 'Riwayat Transaksi',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/treasurer/transaction/history'),
          ),
          MenuItem(
            label: 'Catat Pemasukan',
            icon: Icons.add_circle_outline,
            onTap: () => context.push('/treasurer/incomes'),
          ),
          MenuItem(
            label: 'Catat Pengeluaran',
            icon: Icons.remove_circle_outline,
            onTap: () => context.push('/treasurer/expenses'),
          ),
        ],
      ),
      TabData(
        label: 'Laporan',
        icon: Icons.analytics_rounded,
        items: [
          MenuItem(
            label: 'Laporan Keuangan',
            icon: Icons.description_rounded,
            onTap: () => context.push('/treasurer/financial-report'),
          ),
          MenuItem(
            label: 'Analisis & Grafik',
            icon: Icons.analytics_rounded,
            onTap: () => context.push('/treasurer/analisis'),
          ),
          MenuItem(
            label: 'Transparansi Dana',
            icon: Icons.visibility_rounded,
            onTap: () => context.push('/treasurer/transparency'),
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
        label: 'Iuran Saya',
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

  Widget _buildRecentActivity(BuildContext context) {
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
              onPressed: () => context.push('/treasurer/transaction/history'),
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
          'Iuran RT 03 - Bpk. Ahmad',
          'Rp 500.000',
          '10 menit yang lalu',
          Icons.arrow_downward_rounded,
          AppColors.success,
          true,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Biaya Kebersihan Lingkungan',
          'Rp 300.000',
          '1 jam yang lalu',
          Icons.arrow_upward_rounded,
          AppColors.error,
          false,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          'Iuran RT 07 - Ibu Siti',
          'Rp 500.000',
          '2 jam yang lalu',
          Icons.arrow_downward_rounded,
          AppColors.success,
          true,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String amount,
    String time,
    IconData icon,
    Color color,
    bool isIncome,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isIncome ? 'Masuk' : 'Keluar',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
