import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/community_carousel.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/carousel_item.dart';
import 'package:rukunin/models/menu_item.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: WelcomeRoleCard(
                greeting: 'Selamat datang kembali!',
                role: 'Warga RW 05',
                icon: Icons.home,
              ),
            ),
            const SizedBox(height: 24),
            CommunityCarousel(items: _getCarouselItems()),
            const SizedBox(height: 24),
            MenuTabsSection(tabs: _getMenuTabs(context)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<CarouselItem> _getCarouselItems() {
    return [
      CarouselItem(
        title: 'Kerja Bakti Minggu Ini',
        subtitle: 'Minggu, 15 Januari 2024 • 07:00 WIB',
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
      CarouselItem(
        title: 'Pengumuman: Jadwal Ronda',
        subtitle: 'Perubahan jadwal keamanan malam',
        icon: Icons.campaign_rounded,
        color: AppColors.warning,
        type: 'announcement',
      ),
      CarouselItem(
        title: 'Jatuh Tempo Iuran',
        subtitle: 'Segera bayar iuran bulan ini',
        icon: Icons.payments_rounded,
        color: AppColors.error,
        type: 'payment',
      ),
    ];
  }

  List<TabData> _getMenuTabs(BuildContext context) {
    return [
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
          MenuItem(
            label: 'Status Pengajuan',
            icon: Icons.checklist_rounded,
            onTap: () => context.push('/resident/submission-status'),
          ),
        ],
      ),
      TabData(
        label: 'Komunitas',
        icon: Icons.groups_rounded,
        items: [
          MenuItem(
            label: 'Kalender Kegiatan',
            icon: Icons.event_rounded,
            onTap: () => context.push('/resident/event-calendar'),
          ),
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
            label: 'Kontak Penting',
            icon: Icons.contact_phone_rounded,
            onTap: () => context.push('/resident/emergency-contacts'),
          ),
        ],
      ),
    ];
  }
}
