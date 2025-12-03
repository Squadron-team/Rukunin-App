import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class SecretaryHomeScreen extends StatefulWidget {
  const SecretaryHomeScreen({super.key});

  @override
  State<SecretaryHomeScreen> createState() => _SecretaryHomeScreenState();
}

class _SecretaryHomeScreenState extends State<SecretaryHomeScreen>
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
                    role: 'Sekretaris RW 05',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 20),
                  _compactStats(context),
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

  // ==================== STAT CARD (SAMA PERSIS) ====================
  Widget _compactStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _compactStatCard(
            '8',
            'Pending',
            Icons.pending_actions_rounded,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '12',
            'Selesai',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '3',
            'Rapat',
            Icons.event_rounded,
            AppColors.primary,
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

  // ==================== MENU UTAMA (DESAIN SAMA PERSIS) ====================
  Widget _divisionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Menu Sekretaris',
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
              _buildTab(
                'Surat',
                Icons.description_rounded,
                hasNotification: true,
              ),
              _buildTab('Rapat', Icons.event_note_rounded),
              _buildTab('Data Warga', Icons.people_rounded),
              _buildTab('Administrasi', Icons.folder_rounded),
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
      case 0: // Surat
        return [
          _DivisionItem(
            'Buat Surat',
            Icons.edit_document,
            () => context.push('/secretary/create-letter'),
          ),
          _DivisionItem(
            'Template Surat',
            Icons.article_rounded,
            () => context.push('/secretary/letter-templates'),
          ),
          _DivisionItem(
            'Surat Masuk',
            Icons.mail_rounded,
            () => context.push('/secretary/incoming-mail'),
            badge: '5',
          ),
          _DivisionItem(
            'Surat Keluar',
            Icons.send_rounded,
            () => context.push('/secretary/outgoing-mail'),
          ),
          _DivisionItem(
            'Arsip Surat',
            Icons.archive_rounded,
            () => context.push('/secretary/letter-archive'),
          ),
        ];
      case 1: // Rapat
        return [
          _DivisionItem(
            'Jadwal Rapat',
            Icons.calendar_today_rounded,
            () => context.push('/secretary/meeting-schedule'),
          ),
          _DivisionItem(
            'Notulensi',
            Icons.record_voice_over_rounded,
            () => context.push('/secretary/minutes'),
          ),
          _DivisionItem(
            'Undangan Rapat',
            Icons.mail_outline_rounded,
            () => context.push('/secretary/meeting-invitations'),
          ),
        ];
      case 2: // Data Warga
        return [
          _DivisionItem(
            'Data Warga',
            Icons.people_rounded,
            () => context.push('/secretary/residents-data'),
          ),
          _DivisionItem(
            'Surat Keterangan',
            Icons.badge_rounded,
            () => context.push('/secretary/certificates'),
          ),
        ];
      case 3: // Administrasi (sebelumnya "Permohonan")
        return [
          _DivisionItem(
            'Laporan Bulanan',
            Icons.assessment_rounded,
            () => context.push('/secretary/monthly-reports'),
          ),
          _DivisionItem(
            'Arsip Dokumen',
            Icons.folder_shared_rounded,
            () => context.push('/secretary/archive'),
          ),
          _DivisionItem(
            'Riwayat Surat',
            Icons.history_rounded,
            () => context.push('/secretary/letter-history'),
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

  // MENU CARD (DESAIN 100% SAMA DENGAN VERSI LAMA)
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

  // ==================== AKTIVITAS TERBARU (SAMA PERSIS) ====================
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
          'Surat disetujui RW untuk Ibu Sari',
          '5 menit',
          Icons.check_circle_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Dokumen baru dari Pak Joko',
          '30 menit',
          Icons.edit_document,
          AppColors.primary,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Rapat dijadwalkan Jumat 19:00',
          '1 jam',
          Icons.event_rounded,
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

class _DivisionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  _DivisionItem(this.label, this.icon, this.onTap, {this.badge});
}
