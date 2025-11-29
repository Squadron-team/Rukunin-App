import 'package:flutter/material.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/treasurer/pemasukan/pemasukan_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        QuickAccessItem(
          icon: Icons.add_card,
          label: 'Catat Pemasukan',
          color: AppColors.primary,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PemasukanScreen()),
            );
          },
        ),
        QuickAccessItem(
          icon: Icons.remove_circle_outline,
          label: 'Catat Pengeluaran',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.receipt_long,
          label: 'Riwayat Transaksi',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.people,
          label: 'Data Iuran',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.warning_amber,
          label: 'Tunggakan',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.summarize,
          label: 'Laporan Keuangan',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.category,
          label: 'Kategori',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.analytics,
          label: 'Analisis',
          color: AppColors.primary,
        ),
        QuickAccessItem(
          icon: Icons.print,
          label: 'Cetak Laporan',
          color: AppColors.primary,
        ),
      ],
    );
  }
}
