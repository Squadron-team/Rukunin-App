import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        QuickAccessItem(
          icon: Icons.add_card,
          label: 'Catat Pemasukan',
          color: AppColors.primary,
          onTap: () => context.push('/treasurer/incomes'),
        ),
        QuickAccessItem(
          icon: Icons.remove_circle_outline,
          label: 'Catat Pengeluaran',
          color: AppColors.primary,
          onTap: () => context.push('/treasurer/expenses'),
        ),
        QuickAccessItem(
          icon: Icons.receipt_long,
          label: 'Riwayat Transaksi',
          color: AppColors.primary,
          onTap: () => context.push('/treasurer/transaction/history'),
        ),
        Builder(
          builder: (ctx) {
            final hasPalsu = DataIuranRepository().all().any(
              (e) => (e['prediction'] ?? '') == 'palsu',
            );
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Ensure the QuickAccessItem fills the grid cell
                SizedBox.expand(
                  child: QuickAccessItem(
                    icon: Icons.people,
                    label: 'Data Iuran',
                    color: AppColors.primary,
                    onTap: () => context.push('/treasurer/dues'),
                  ),
                ),
                if (hasPalsu)
                  Positioned(
                    // place the badge inside the card (top-right corner)
                    top: 12,
                    right: 12,
                    child: IgnorePointer(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const QuickAccessItem(
          icon: Icons.category,
          label: 'Kategori',
          color: AppColors.primary,
        ),
        const QuickAccessItem(
          icon: Icons.analytics,
          label: 'Analisis',
          color: AppColors.primary,
        ),
      ],
    );
  }
}
