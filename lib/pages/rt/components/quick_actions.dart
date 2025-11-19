import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/pages/rt/announcements/announcements_screen.dart';
import 'package:rukunin/pages/rt/warga/warga_list_screen.dart';
import 'package:rukunin/pages/rt/warga/data_kk_screen.dart';
import 'package:rukunin/pages/rt/events/events_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;
    final gridBottom = bottomSafe + 28.0; // extra room to avoid tiny overflows

    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: GridView.count(
        padding: EdgeInsets.only(bottom: gridBottom),
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        // increase tile height so labels (eg. "Pengumuman RT") don't get cut
        childAspectRatio: 0.8,
        children: [
        QuickAccessItem(
          icon: Icons.person_add,
          label: 'Daftar Warga',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WargaListScreen()),
            );
          },
        ),
        QuickAccessItem(
          icon: Icons.list_alt,
          label: 'Data KK',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataKkScreen()),
            );
          },
        ),
        QuickAccessItem(
          icon: Icons.event_available,
          label: 'Kegiatan RT',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommunityHeadEventsScreen()),
            );
          },
        ),
        const QuickAccessItem(
          icon: Icons.payment,
          label: 'Catat Iuran',
          color: AppColors.primary,
        ),
        const QuickAccessItem(
          icon: Icons.report,
          label: 'Kelola Laporan',
          color: AppColors.primary,
        ),
        const QuickAccessItem(
          icon: Icons.edit_document,
          label: 'Buat Surat',
          color: AppColors.primary,
        ),
        const QuickAccessItem(
          icon: Icons.campaign,
          label: 'Pengumuman RT',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
            );
          },
        ),
        const QuickAccessItem(
          icon: Icons.insert_chart,
          label: 'Laporan RT',
          color: AppColors.primary,
        ),
        const QuickAccessItem(
          icon: Icons.people_outline,
          label: 'Rapat RT',
          color: AppColors.primary,
        ),
      ],
      ),
    );
  }
}
