import 'package:flutter/material.dart';
import 'package:rukunin/pages/community_head/community_head_layout.dart';
import 'package:rukunin/pages/community_head/components/stat_card.dart';
import 'package:rukunin/pages/community_head/components/street_card.dart';
import 'package:rukunin/pages/community_head/components/activity_card.dart';
import 'package:rukunin/pages/community_head/components/welcome_card.dart';
import 'package:rukunin/pages/community_head/components/financial_summary.dart';
import 'package:rukunin/pages/community_head/components/quick_actions.dart';
import 'package:rukunin/pages/community_head/components/pending_tasks.dart';

class CommunityHeadHomeScreen extends StatelessWidget {
  const CommunityHeadHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityHeadLayout(
      title: 'Dashboard RT',
      currentIndex: 0,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeCard(),

              const SizedBox(height: 24),

              // RT Statistics
              const Text(
                'Statistik RT 03',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: const StatCard(
                      icon: Icons.payment,
                      label: 'Iuran Terbayar',
                      value: '38/45',
                      subtitle: '84%',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const StatCard(
                      icon: Icons.report_problem,
                      label: 'Laporan Aktif',
                      value: '3',
                      subtitle: 'Perlu tindakan',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: const StatCard(
                      icon: Icons.event,
                      label: 'Kegiatan Bulan Ini',
                      value: '4',
                      subtitle: '2 mendatang',
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const StatCard(
                      icon: Icons.description,
                      label: 'Pengajuan Surat',
                      value: '5',
                      subtitle: '2 pending',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Resident Summary by Street/Gang
              const Text(
                'Wilayah RT 03',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              const StreetCard(
                streetName: 'Gang Mawar',
                totalHouses: 12,
                paidDues: 11,
                status: 'Sangat Baik',
                statusColor: Colors.blue,
              ),

              const StreetCard(
                streetName: 'Gang Melati',
                totalHouses: 15,
                paidDues: 13,
                status: 'Baik',
                statusColor: Colors.green,
              ),

              const StreetCard(
                streetName: 'Gang Anggrek',
                totalHouses: 10,
                paidDues: 8,
                status: 'Baik',
                statusColor: Colors.green,
              ),

              const StreetCard(
                streetName: 'Gang Dahlia',
                totalHouses: 8,
                paidDues: 6,
                status: 'Perlu Perhatian',
                statusColor: Colors.orange,
              ),

              const SizedBox(height: 32),

              const Text(
                'Menu RT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const QuickActionsGrid(),

              const SizedBox(height: 32),

              // Recent Activities
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              const ActivityCard(
                icon: Icons.payment,
                title: 'Pembayaran Iuran',
                subtitle: 'Pak Budi (Gang Mawar 15) membayar iuran November',
                time: '5 menit yang lalu',
                color: Colors.blue,
              ),

              const ActivityCard(
                icon: Icons.description,
                title: 'Pengajuan Surat',
                subtitle: 'Ibu Siti mengajukan surat pengantar RT',
                time: '30 menit yang lalu',
                color: Colors.teal,
              ),

              const ActivityCard(
                icon: Icons.report,
                title: 'Laporan Baru',
                subtitle: 'Lampu jalan mati di Gang Dahlia',
                time: '1 jam yang lalu',
                color: Colors.orange,
              ),

              const ActivityCard(
                icon: Icons.person_add,
                title: 'Warga Baru',
                subtitle: 'Keluarga Wijaya pindah ke Gang Melati 08',
                time: '2 jam yang lalu',
                color: Colors.green,
              ),

              const ActivityCard(
                icon: Icons.event,
                title: 'Kegiatan Terjadwal',
                subtitle: 'Posyandu RT 03, Kamis 16 Nov pukul 08:00',
                time: '3 jam yang lalu',
                color: Colors.purple,
              ),

              const SizedBox(height: 32),

              const FinancialSummary(),

              const SizedBox(height: 32),

              const PendingTasks(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}