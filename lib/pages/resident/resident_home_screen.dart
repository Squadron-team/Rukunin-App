import 'package:flutter/material.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResidentLayout(
      title: 'Selamat pagi, Pak Eko!',
      currentIndex: 0,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Quick Access
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  QuickAccessItem(
                    icon: Icons.payment,
                    label: 'Iuran',
                    color: AppColors.primary,
                  ),
                  QuickAccessItem(
                    icon: Icons.article_outlined,
                    label: 'Pengumuman',
                    color: AppColors.primary,
                  ),
                  QuickAccessItem(
                    icon: Icons.event,
                    label: 'Kegiatan',
                    color: AppColors.primary,
                  ),
                  QuickAccessItem(
                    icon: Icons.people_outline,
                    label: 'Warga',
                    color: AppColors.primary,
                  ),
                  QuickAccessItem(
                    icon: Icons.report_problem_outlined,
                    label: 'Laporan',
                    color: AppColors.primary,
                  ),
                  QuickAccessItem(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
