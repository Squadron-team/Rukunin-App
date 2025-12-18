import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
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
            MenuTabsSection(
              tabs: _getMenuTabs(context),
              sectionTitle: 'Menu Sekretaris',
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
            label: 'Template Surat',
            icon: Icons.article_rounded,
            onTap: () => context.push('/secretary/letter-templates'),
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
            label: 'Arsip Surat',
            icon: Icons.archive_rounded,
            onTap: () => context.push('/secretary/letter-archive'),
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
        label: 'Data Warga',
        icon: Icons.people_rounded,
        items: [
          MenuItem(
            label: 'Data Warga',
            icon: Icons.people_rounded,
            onTap: () => context.push('/secretary/residents-data'),
          ),
          MenuItem(
            label: 'Surat Keterangan',
            icon: Icons.badge_rounded,
            onTap: () => context.push('/secretary/certificates'),
          ),
        ],
      ),
      TabData(
        label: 'Administrasi',
        icon: Icons.folder_rounded,
        items: [
          MenuItem(
            label: 'Laporan Bulanan',
            icon: Icons.assessment_rounded,
            onTap: () => context.push('/secretary/monthly-reports'),
          ),
          MenuItem(
            label: 'Arsip Dokumen',
            icon: Icons.folder_shared_rounded,
            onTap: () => context.push('/secretary/archive'),
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
