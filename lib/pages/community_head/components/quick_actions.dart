import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';

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
        children: const [
        QuickAccessItem(
          icon: Icons.person_add,
          label: 'Daftar Warga',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.list_alt,
          label: 'Data KK',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.event_available,
          label: 'Kegiatan RT',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.payment,
          label: 'Catat Iuran',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.report,
          label: 'Kelola Laporan',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.edit_document,
          label: 'Buat Surat',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.campaign,
          label: 'Pengumuman RT',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.insert_chart,
          label: 'Laporan RT',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.people_outline,
          label: 'Rapat RT',
          color: AppColors.primary,
        ),
      ],
      ),
    );
  }
}
