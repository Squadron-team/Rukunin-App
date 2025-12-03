import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class RwHomeScreen extends StatefulWidget {
  const RwHomeScreen({super.key});

  @override
  State<RwHomeScreen> createState() => _RwHomeScreenState();
}

class _RwHomeScreenState extends State<RwHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const totalWarga = 248;
    const totalKeuangan = 'Rp 45.8 Jt';

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
                  _compactStats(context, totalWarga, totalKeuangan),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _divisionsSection(context),
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

  Widget _compactStats(
    BuildContext context,
    int totalWarga,
    String totalKeuangan,
  ) {
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
            totalWarga.toString(),
            'Warga',
            Icons.people_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            totalKeuangan,
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

  Widget _divisionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Menu RW',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: [
              _buildTab('RT', Icons.apartment_rounded, hasNotification: false),
              _buildTab(
                'Kegiatan',
                Icons.event_note_rounded,
                hasNotification: true,
              ),
              _buildTab(
                'Keuangan',
                Icons.account_balance_rounded,
                hasNotification: false,
              ),
              _buildTab(
                'Keamanan',
                Icons.security_rounded,
                hasNotification: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            return _buildTabContent(
              context: context,
              items: _getItemsForTab(_tabController.index),
            );
          },
        ),
      ],
    );
  }

  List<_DivisionItem> _getItemsForTab(int index) {
    switch (index) {
      case 0:
        return [
          _DivisionItem(
            'Daftar RT',
            Icons.view_list_rounded,
            () => context.push('/rw/rt-list'),
          ),
          _DivisionItem(
            'Kinerja RT',
            Icons.analytics_rounded,
            () => context.push('/rw/rt-performance'),
          ),
          _DivisionItem(
            'Data Warga',
            Icons.people_rounded,
            () => context.push('/rw/data-warga'),
          ),
        ];
      case 1:
        return [
          _DivisionItem(
            'Kegiatan RW',
            Icons.event_rounded,
            () => context.push('/rw/kegiatan'),
            badge: '2',
          ),
          _DivisionItem(
            'Rapat',
            Icons.meeting_room_rounded,
            () => context.push('/rw/rapat'),
            badge: '1',
          ),
          _DivisionItem(
            'Pengumuman',
            Icons.campaign_rounded,
            () => context.push('/rw/pengumuman'),
          ),
        ];
      case 2:
        return [
          _DivisionItem(
            'Iuran Warga',
            Icons.payments_rounded,
            () => context.push('/rw/iuran'),
          ),
          _DivisionItem(
            'Ringkasan RT',
            Icons.summarize_rounded,
            () => context.push('/rw/finance-summary'),
          ),
          _DivisionItem(
            'Laporan',
            Icons.receipt_long_rounded,
            () => context.push('/rw/finance-report'),
          ),
        ];
      case 3:
        return [
          _DivisionItem(
            'Laporan',
            Icons.report_rounded,
            () => context.push('/rw/laporan'),
            badge: '3',
          ),
          _DivisionItem(
            'Monitoring',
            Icons.my_location_rounded,
            () => context.push('/rw/monitoring'),
          ),
          _DivisionItem(
            'Surat',
            Icons.description_rounded,
            () => context.push('/rw/surat'),
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildTab(
    String label,
    IconData icon, {
    bool hasNotification = false,
  }) {
    return Tab(
      height: 44,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label),
            if (hasNotification) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required BuildContext context,
    required List<_DivisionItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _menuItem(
                  context: context,
                  label: item.label,
                  icon: item.icon,
                  onTap: item.onTap,
                  badge: item.badge,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ketuk untuk membuka',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
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

class _DivisionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  _DivisionItem(this.label, this.icon, this.onTap, {this.badge});
}
