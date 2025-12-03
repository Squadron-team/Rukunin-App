import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _carouselController = PageController();
  int _currentCarouselPage = 0;
  Timer? _carouselTimer;

  final List<_CarouselItem> _carouselItems = [
    _CarouselItem(
      title: 'Kerja Bakti Minggu Ini',
      subtitle: 'Minggu, 15 Januari 2024 • 07:00 WIB',
      icon: Icons.cleaning_services_rounded,
      color: AppColors.success,
      type: 'event',
    ),
    _CarouselItem(
      title: 'Pengumuman: Jadwal Ronda',
      subtitle: 'Perubahan jadwal keamanan malam',
      icon: Icons.campaign_rounded,
      color: AppColors.warning,
      type: 'announcement',
    ),
    _CarouselItem(
      title: 'Jatuh Tempo Iuran',
      subtitle: 'Segera bayar iuran bulan ini',
      icon: Icons.payments_rounded,
      color: AppColors.error,
      type: 'payment',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_currentCarouselPage + 1) % _carouselItems.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _tabController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  WelcomeRoleCard(
                    greeting: 'Selamat datang kembali!',
                    role: 'Warga RW 05',
                    icon: Icons.home,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _communityUpdatesCarousel(),
            const SizedBox(height: 24),
            _divisionsSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _communityUpdatesCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'Info Penting',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() => _currentCarouselPage = index);
            },
            itemCount: _carouselItems.length,
            itemBuilder: (context, index) {
              final item = _carouselItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCarouselCard(item),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carouselItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == _currentCarouselPage ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == _currentCarouselPage
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(_CarouselItem item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [item.color, item.color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.type == 'event'
                      ? 'KEGIATAN'
                      : item.type == 'announcement'
                      ? 'PENGUMUMAN'
                      : 'PEMBAYARAN',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: item.color,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
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
            'Menu Warga',
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
              _buildTab('Iuran', Icons.payments_rounded, hasNotification: true),
              _buildTab(
                'Layanan',
                Icons.description_rounded,
                hasNotification: false,
              ),
              _buildTab(
                'Komunitas',
                Icons.groups_rounded,
                hasNotification: false,
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
      case 0: // Iuran
        return [
          _DivisionItem(
            'Bayar Iuran',
            Icons.payment_rounded,
            () => context.push('/resident/community/dues'),
            badge: '1',
          ),
          _DivisionItem(
            'Riwayat Pembayaran',
            Icons.history_rounded,
            () => context.push('/resident/payment-history'),
          ),
          _DivisionItem(
            'Kwitansi Digital',
            Icons.receipt_long_rounded,
            () => context.push('/resident/digital-receipts'),
          ),
        ];
      case 1: // Layanan
        return [
          _DivisionItem(
            'Ajukan Surat',
            Icons.description_rounded,
            () => context.push('/resident/community/documents'),
          ),
          _DivisionItem(
            'Lapor Masalah',
            Icons.report_problem_rounded,
            () => context.push('/resident/report-issue'),
          ),
          _DivisionItem(
            'Kirim Saran',
            Icons.feedback_rounded,
            () => context.push('/resident/submit-suggestion'),
          ),
          _DivisionItem(
            'Status Pengajuan',
            Icons.checklist_rounded,
            () => context.push('/resident/submission-status'),
          ),
        ];
      case 2: // Komunitas
        return [
          _DivisionItem(
            'Kalender Kegiatan',
            Icons.event_rounded,
            () => context.push('/resident/event-calendar'),
          ),
          _DivisionItem(
            'Pengumuman',
            Icons.campaign_rounded,
            () => context.push('/resident/announcements'),
          ),
          _DivisionItem(
            'Data Warga',
            Icons.people_rounded,
            () => context.push('/resident/residents-directory'),
          ),
          _DivisionItem(
            'Kontak Penting',
            Icons.contact_phone_rounded,
            () => context.push('/resident/emergency-contacts'),
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
}

class _DivisionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  _DivisionItem(this.label, this.icon, this.onTap, {this.badge});
}

class _CarouselItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type;

  _CarouselItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.type,
  });
}
