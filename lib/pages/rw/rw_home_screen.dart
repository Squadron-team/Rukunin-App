import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rw/iuran/iuran_rw_screen.dart';
import 'package:rukunin/pages/rw/kegiatan/kegiatan_rw_screen.dart';
import 'package:rukunin/pages/rw/laporan/kelola_laporan_screen.dart';
import 'package:rukunin/pages/rw/pengumuman/pengumuman_screen.dart';
import 'package:rukunin/pages/rw/rapat/rapat_rw_screen.dart';
import 'package:rukunin/pages/rw/surat/surat_menyurat_screen.dart';
import 'package:rukunin/pages/rw/data_warga/data_warga_screen.dart';
import 'package:rukunin/modules/notification/pages/notification_screen.dart';
import 'package:rukunin/widgets/quick_access_item.dart';

class RwHomeScreen extends StatelessWidget {
  const RwHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalWarga = 248;
    const totalKeuangan = 'Rp 45.8 Jt';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Selamat pagi, Bu RW!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _header(),
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

  // ========================= HEADER =========================
  Widget _header() {
    return Container(
      width: double.infinity,
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
          const Text(
            'Selamat Datang, Budi Santoso! 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola aktivitas RW 05 dengan mudah',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Ketua RW 05',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickStatCard(
            'Pengumuman',
            '5',
            Icons.campaign_rounded,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickStatCard(
            'Rapat Hari Ini',
            '1',
            Icons.event_rounded,
            Colors.purple,
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
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
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

  // ========================= INSIGHT SECTION =========================
  Widget _insightSection(
    BuildContext context,
    int totalWarga,
    String totalKeuangan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Statistik Utama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _insightCard(
          context: context,
          title: 'Total RT',
          value: '12 RT',
          subtitle: 'Di wilayah RW 05',
          icon: Icons.home_work_rounded,
          color: Colors.indigo,
          trend: '+2 RT baru',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _insightCard(
                context: context,
                title: 'Jumlah Warga',
                value: totalWarga.toString(),
                subtitle: 'Terdaftar aktif',
                icon: Icons.people_rounded,
                color: Colors.blue,
                page: const DataWargaScreen(),
                trend: '+12 bulan ini',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _insightCard(
                context: context,
                title: 'Total Keuangan',
                value: totalKeuangan,
                subtitle: 'Saldo tersedia',
                icon: Icons.account_balance_wallet_rounded,
                color: Colors.green,
                page: const IuranRwScreen(),
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
    Widget? page,
  }) {
    final bool clickable = page != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: clickable
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  if (clickable)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: color,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (trend != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 11,
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

  // ========================= MENU GRID =========================
  Widget _menuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Menu Layanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.9,
          children: [
            QuickAccessItem(
              icon: Icons.people_rounded,
              label: 'Data Warga',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DataWargaScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.payments_rounded,
              label: 'Iuran',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IuranRwScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.event_rounded,
              label: 'Kegiatan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KegiatanRwScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.receipt_long_rounded,
              label: 'Laporan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const KelolaLaporanScreen(),
                  ),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.campaign_rounded,
              label: 'Pengumuman',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PengumumanScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.meeting_room_rounded,
              label: 'Rapat',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RapatRwScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.description_rounded,
              label: 'Surat',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuratMenyuratScreen(),
                  ),
                );
              },
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
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _activityItem(
          'Laporan kebersihan diterima',
          '2 jam yang lalu',
          Icons.report_rounded,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _activityItem(
          'Rapat RT 03 dijadwalkan',
          '5 jam yang lalu',
          Icons.event_rounded,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _activityItem(
          'Iuran Agustus - 85% terkumpul',
          '1 hari yang lalu',
          Icons.payments_rounded,
          Colors.green,
        ),
      ],
    );
  }

  Widget _activityItem(String title, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
