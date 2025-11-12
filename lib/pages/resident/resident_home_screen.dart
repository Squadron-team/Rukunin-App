import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/event_card.dart';
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
              // Upcoming Events
              const Text(
                'Kegiatan mendatang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 300,
                child: PageView(
                  controller: PageController(viewportFraction: 0.9),
                  children: [
                    EventCard(
                      event: Event(
                        category: 'Pendidikan',
                        title: 'Pelatihan UMKM',
                        location: 'Rumah Bu Rosi',
                        date: '12 November 2025',
                        time: '09.00 WIB',
                        categoryColor: const Color(0xFFBDBDBD),
                      ),
                    ),
                    EventCard(
                      event: Event(
                        category: 'Sosial',
                        title: 'Kerja Bakti',
                        location: 'Balai Warga',
                        date: '15 November 2025',
                        time: '07.00 WIB',
                        categoryColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == 0 ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xFFBDBDBD)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

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
