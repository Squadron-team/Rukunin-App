import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/components/stat_card.dart';
import 'package:rukunin/pages/rt/components/activity_card.dart';
import 'package:rukunin/pages/rt/components/financial_summary.dart';
import 'package:rukunin/pages/rt/components/quick_actions.dart';
import 'package:rukunin/pages/rt/components/pending_tasks.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';

class RtHomeScreen extends StatelessWidget {
  const RtHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeRoleCard(
                greeting: 'Selamat datang kembali!',
                role: 'Ketua RT 03',
                icon: Icons.home,
              ),

              SizedBox(height: 24),

              // RT Statistics
              Text(
                'Statistik RT 03',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.payment,
                      label: 'Iuran Terbayar',
                      value: '38/45',
                      subtitle: '84%',
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.report_problem,
                      label: 'Laporan Aktif',
                      value: '3',
                      subtitle: 'Perlu tindakan',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.event,
                      label: 'Kegiatan Bulan Ini',
                      value: '4',
                      subtitle: '2 mendatang',
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.description,
                      label: 'Pengajuan Surat',
                      value: '5',
                      subtitle: '2 pending',
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              Text(
                'Menu RT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

              QuickActionsGrid(),

              SizedBox(height: 32),

              // Recent Activities
              Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

              ActivityCard(
                icon: Icons.payment,
                title: 'Pembayaran Iuran',
                subtitle: 'Pak Budi (Gang Mawar 15) membayar iuran November',
                time: '5 menit yang lalu',
                color: AppColors.primary,
              ),

              ActivityCard(
                icon: Icons.description,
                title: 'Pengajuan Surat',
                subtitle: 'Ibu Siti mengajukan surat pengantar RT',
                time: '30 menit yang lalu',
                color: AppColors.primary,
              ),

              ActivityCard(
                icon: Icons.report,
                title: 'Laporan Baru',
                subtitle: 'Lampu jalan mati di Gang Dahlia',
                time: '1 jam yang lalu',
                color: AppColors.warning,
              ),

              ActivityCard(
                icon: Icons.person_add,
                title: 'Warga Baru',
                subtitle: 'Keluarga Wijaya pindah ke Gang Melati 08',
                time: '2 jam yang lalu',
                color: AppColors.success,
              ),

              ActivityCard(
                icon: Icons.event,
                title: 'Kegiatan Terjadwal',
                subtitle: 'Posyandu RT 03, Kamis 16 Nov pukul 08:00',
                time: '3 jam yang lalu',
                color: AppColors.primary,
              ),

              SizedBox(height: 32),

              FinancialSummary(),

              SizedBox(height: 32),

              PendingTasks(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
