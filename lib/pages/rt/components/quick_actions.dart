import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/pages/rt/announcements/announcements_screen.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_list_screen.dart';
import 'package:rukunin/pages/rt/warga/list_keluarga/family_list_screen.dart';
import 'package:rukunin/pages/rt/events/events_screen.dart';
import 'package:rukunin/pages/rt/wilayah/wilayah_rt_screen.dart';
import 'package:rukunin/pages/rt/surat_form_warga/kelola_pengajuan_surat_screen.dart';
import 'package:rukunin/pages/rt/surat_to_rw/screen.dart';
import 'package:rukunin/pages/rt/reports/manage_reports_screen.dart';
import 'package:rukunin/pages/rt/report_statistic/laporan_rt_screen.dart';
import 'package:rukunin/pages/rt/mutasi/mutasi_list_screen.dart';
import 'package:rukunin/pages/rt/meetings/meetings_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;
    final gridBottom = bottomSafe + 28.0;

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
            icon: Icons.family_restroom,
            label: 'Data Keluarga',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyListScreen()),
              );
            },
          ),
          QuickAccessItem(
            icon: Icons.map,
            label: 'Wilayah RT',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WilayahRtScreen()),
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
                MaterialPageRoute(
                  builder: (_) => const CommunityHeadEventsScreen(),
                ),
              );
            },
          ),
          const QuickAccessItem(
            icon: Icons.payment,
            label: 'Catat Iuran',
            color: AppColors.primary,
          ),
          QuickAccessItem(
            icon: Icons.report,
            label: 'Kelola Laporan Warga',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageReportsScreen()),
              );
            },
          ),
          QuickAccessItem(
            icon: Icons.edit_document,
            label: 'Buat Surat',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateRtToRwLetterScreen(),
                ),
              );
            },
          ),
          QuickAccessItem(
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
          QuickAccessItem(
            icon: Icons.mail,
            label: 'Kelola Pengajuan Surat',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KelolaPengajuanSuratScreen(),
                ),
              );
            },
          ),
          QuickAccessItem(
            icon: Icons.swap_horiz,
            label: 'Catat Mutasi',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MutasiListScreen()),
              );
            },
          ),
          QuickAccessItem(
            icon: Icons.insert_chart,
            label: 'Laporan RT',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LaporanRTScreen()),
              );
            },
          ),
          QuickAccessItem(
            icon: Icons.people_outline,
            label: 'Rapat RT',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeetingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
