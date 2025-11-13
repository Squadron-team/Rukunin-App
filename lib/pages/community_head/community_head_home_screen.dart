import 'package:flutter/material.dart';
import 'package:rukunin/pages/community_head/community_head_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';

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
              // Welcome Card with RT Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.home_work,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat datang, Pak RT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'RT 03 RW 05 - Tegalharjo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '45 KK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '168 Jiwa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

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
                    child: _buildStatCard(
                      icon: Icons.payment,
                      label: 'Iuran Terbayar',
                      value: '38/45',
                      subtitle: '84%',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
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
                    child: _buildStatCard(
                      icon: Icons.event,
                      label: 'Kegiatan Bulan Ini',
                      value: '4',
                      subtitle: '2 mendatang',
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
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

              _buildStreetCard(
                streetName: 'Gang Mawar',
                totalHouses: 12,
                paidDues: 11,
                status: 'Sangat Baik',
                statusColor: Colors.blue,
              ),

              _buildStreetCard(
                streetName: 'Gang Melati',
                totalHouses: 15,
                paidDues: 13,
                status: 'Baik',
                statusColor: Colors.green,
              ),

              _buildStreetCard(
                streetName: 'Gang Anggrek',
                totalHouses: 10,
                paidDues: 8,
                status: 'Baik',
                statusColor: Colors.green,
              ),

              _buildStreetCard(
                streetName: 'Gang Dahlia',
                totalHouses: 8,
                paidDues: 6,
                status: 'Perlu Perhatian',
                statusColor: Colors.orange,
              ),

              const SizedBox(height: 32),

              // Quick Actions for Community Head
              const Text(
                'Menu RT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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

              _buildActivityCard(
                icon: Icons.payment,
                title: 'Pembayaran Iuran',
                subtitle: 'Pak Budi (Gang Mawar 15) membayar iuran November',
                time: '5 menit yang lalu',
                color: Colors.blue,
              ),

              _buildActivityCard(
                icon: Icons.description,
                title: 'Pengajuan Surat',
                subtitle: 'Ibu Siti mengajukan surat pengantar RT',
                time: '30 menit yang lalu',
                color: Colors.teal,
              ),

              _buildActivityCard(
                icon: Icons.report,
                title: 'Laporan Baru',
                subtitle: 'Lampu jalan mati di Gang Dahlia',
                time: '1 jam yang lalu',
                color: Colors.orange,
              ),

              _buildActivityCard(
                icon: Icons.person_add,
                title: 'Warga Baru',
                subtitle: 'Keluarga Wijaya pindah ke Gang Melati 08',
                time: '2 jam yang lalu',
                color: Colors.green,
              ),

              _buildActivityCard(
                icon: Icons.event,
                title: 'Kegiatan Terjadwal',
                subtitle: 'Posyandu RT 03, Kamis 16 Nov pukul 08:00',
                time: '3 jam yang lalu',
                color: Colors.purple,
              ),

              const SizedBox(height: 32),

              // Financial Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Kas RT Bulan Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Iuran Terkumpul',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Rp 1.900.000',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Target',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Rp 2.250.000',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.844,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '84.4% Tercapai',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '38/45 KK Bayar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo Kas RT',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Rp 3.450.000',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Navigate to financial details
                          },
                          icon: const Icon(Icons.remove_red_eye, size: 16),
                          label: const Text('Detail'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Pending Tasks
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.1),
                      Colors.orange.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.pending_actions,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tugas Menunggu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTaskItem(
                      '7 KK belum bayar iuran November',
                      Icons.payment,
                      Colors.red,
                    ),
                    _buildTaskItem(
                      '2 pengajuan surat menunggu persetujuan',
                      Icons.description,
                      Colors.orange,
                    ),
                    _buildTaskItem(
                      '3 laporan menunggu tindak lanjut',
                      Icons.report_problem,
                      Colors.orange,
                    ),
                    _buildTaskItem(
                      '1 data warga baru perlu verifikasi',
                      Icons.person_add,
                      Colors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreetCard({
    required String streetName,
    required int totalHouses,
    required int paidDues,
    required String status,
    required Color statusColor,
  }) {
    final paymentPercentage = (paidDues / totalHouses * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streetName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalHouses Rumah • $paidDues/$totalHouses Bayar ($paymentPercentage%)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}