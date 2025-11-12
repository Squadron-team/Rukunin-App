import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/event_card.dart';
import 'package:rukunin/widgets/quick_access_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Selamat pagi, Pak Eko!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upcoming Events Section
              const Text(
                'Kegiatan mendatang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Events Carousel
              SizedBox(
                height: 250,
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

              // Dots Indicator
              const SizedBox(height: 12),
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

              // Quick Access Section
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Quick Access Grid
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Pasar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Iuran',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
