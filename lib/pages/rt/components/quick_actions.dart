import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/widgets/menu_card.dart';

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
          MenuCard(
            icon: Icons.person_add,
            label: 'Daftar Warga',
            onTap: () => context.push('/rt/warga/list'),
          ),
          MenuCard(
            icon: Icons.family_restroom,
            label: 'Data Keluarga',
            onTap: () => context.push('/rt/warga/family'),
          ),
          MenuCard(
            icon: Icons.map,
            label: 'Wilayah RT',
            onTap: () => context.push('/rt/wilayah'),
          ),
          MenuCard(
            icon: Icons.event_available,
            label: 'Kegiatan RT',
            onTap: () => context.push('/rt/events'),
          ),
          MenuCard(
            icon: Icons.payment,
            label: 'Catat Iuran',
            onTap: () => context.push('/rt/iuran'),
          ),
          MenuCard(
            icon: Icons.report,
            label: 'Kelola Laporan Warga',
            onTap: () => context.push('/rt/reports/manage'),
          ),
          MenuCard(
            icon: Icons.edit_document,
            label: 'Buat Surat',
            onTap: () => context.push('/rt/surat/create'),
          ),
          MenuCard(
            icon: Icons.campaign,
            label: 'Pengumuman RT',
            onTap: () => context.push('/rt/announcements'),
          ),
          MenuCard(
            icon: Icons.mail,
            label: 'Kelola Pengajuan Surat',
            onTap: () => context.push('/rt/surat/pengajuan'),
          ),
          MenuCard(
            icon: Icons.swap_horiz,
            label: 'Catat Mutasi',
            onTap: () => context.push('/rt/mutasi'),
          ),
          MenuCard(
            icon: Icons.insert_chart,
            label: 'Laporan RT',
            onTap: () => context.push('/rt/reports/statistic'),
          ),
          MenuCard(
            icon: Icons.people_outline,
            label: 'Rapat RT',
            onTap: () => context.push('/rt/meetings'),
          ),
        ],
      ),
    );
  }
}
