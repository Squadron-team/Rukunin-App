import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/quick_access_item.dart';
import 'package:rukunin/modules/notification/pages/notification_screen.dart';
import 'package:rukunin/pages/secretary/pages/create_letter_screen.dart';
import 'package:rukunin/pages/secretary/pages/verification_screen.dart';
import 'package:rukunin/pages/secretary/pages/archive_screen.dart';
import 'package:rukunin/pages/secretary/pages/meeting_schedule_screen.dart';
import 'package:rukunin/pages/secretary/pages/minutes_screen.dart';
import 'package:rukunin/pages/secretary/pages/incoming_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/outgoing_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/residents_data_screen.dart';
import 'package:rukunin/pages/secretary/pages/reports_screen.dart';

class SecretaryHomeScreen extends StatefulWidget {
  const SecretaryHomeScreen({super.key});

  @override
  State<SecretaryHomeScreen> createState() => _SecretaryHomeScreenState();
}

class _SecretaryHomeScreenState extends State<SecretaryHomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _documents = [
    {
      'type': 'Surat Keterangan',
      'pending': 3,
      'approved': 8,
      'rejected': 1,
      'icon': Icons.article,
      'color': Colors.blue,
    },
    {
      'type': 'Surat Pengantar',
      'pending': 2,
      'approved': 12,
      'rejected': 0,
      'icon': Icons.description,
      'color': Colors.green,
    },
    {
      'type': 'Surat Domisili',
      'pending': 1,
      'approved': 5,
      'rejected': 1,
      'icon': Icons.home_work,
      'color': Colors.orange,
    },
    {
      'type': 'Dokumen Lainnya',
      'pending': 2,
      'approved': 7,
      'rejected': 0,
      'icon': Icons.folder_open,
      'color': Colors.purple,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => _navigateToNotification(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[50],
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: 24),
                  _buildTodaySummary(),
                  const SizedBox(height: 32),
                  _buildDocumentStatus(),
                  const SizedBox(height: 32),
                  _buildSecretaryMenu(),
                  const SizedBox(height: 32),
                  _buildPendingApprovals(),
                  const SizedBox(height: 32),
                  _buildRecentActivities(),
                  const SizedBox(height: 32),
                  _buildUpcomingMeetings(),
                  const SizedBox(height: 30),
                  _buildDocumentStats(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToNotification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  }

  Widget _buildTodaySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Tugas Hari Ini',
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
                Icons.pending_actions,
                'Tugas Pending',
                '8',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.check_circle,
                'Selesai Hari Ini',
                '12',
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                Icons.description,
                'Surat Diproses',
                '5',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.event_note,
                'Rapat Minggu Ini',
                '3',
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status Dokumen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
              scrollbars: false,
            ),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _documents.length,
              itemBuilder: (_, i) {
                final doc = _documents[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildDocumentCard(
                    type: doc['type'],
                    pending: doc['pending'],
                    approved: doc['approved'],
                    rejected: doc['rejected'],
                    icon: doc['icon'],
                    color: doc['color'],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _documents.length,
            (i) => GestureDetector(
              onTap: () => _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? AppColors.primary
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecretaryMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Sekretaris',
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
          children: [
            QuickAccessItem(
              icon: Icons.edit_document,
              label: 'Buat Surat',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const CreateLetterScreen()),
            ),
            QuickAccessItem(
              icon: Icons.approval,
              label: 'Verifikasi',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const VerificationScreen()),
            ),
            QuickAccessItem(
              icon: Icons.folder_shared,
              label: 'Arsip',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const ArchiveScreen()),
            ),
            QuickAccessItem(
              icon: Icons.calendar_today,
              label: 'Jadwal Rapat',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const MeetingScheduleScreen()),
            ),
            QuickAccessItem(
              icon: Icons.record_voice_over,
              label: 'Notulensi',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const MinutesScreen()),
            ),
            QuickAccessItem(
              icon: Icons.mail_outline,
              label: 'Surat Masuk',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const IncomingMailScreen()),
            ),
            QuickAccessItem(
              icon: Icons.send,
              label: 'Surat Keluar',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const OutgoingMailScreen()),
            ),
            QuickAccessItem(
              icon: Icons.list_alt,
              label: 'Data Warga',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const ResidentsDataScreen()),
            ),
            QuickAccessItem(
              icon: Icons.assessment,
              label: 'Laporan',
              color: AppColors.primary,
              onTap: () => _navigateToScreen(const ReportsScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPendingApprovals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menunggu Persetujuan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildApprovalCard(
          title: 'Surat Keterangan Domisili',
          requester: 'Budi Santoso - RT 03/15',
          time: '10 menit yang lalu',
          icon: Icons.home_work,
          color: Colors.blue,
        ),
        _buildApprovalCard(
          title: 'Surat Pengantar SKCK',
          requester: 'Siti Aminah - RT 02/08',
          time: '25 menit yang lalu',
          icon: Icons.description,
          color: Colors.green,
        ),
        _buildApprovalCard(
          title: 'Surat Keterangan Usaha',
          requester: 'Ahmad Wijaya - RT 01/12',
          time: '1 jam yang lalu',
          icon: Icons.business,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          icon: Icons.check_circle,
          title: 'Surat Disetujui',
          subtitle: 'Surat pengantar untuk Ibu Sari telah disetujui RW',
          time: '5 menit yang lalu',
          color: Colors.green,
        ),
        _buildActivityCard(
          icon: Icons.edit_document,
          title: 'Dokumen Dibuat',
          subtitle: 'Surat keterangan domisili untuk Pak Joko',
          time: '30 menit yang lalu',
          color: Colors.blue,
        ),
        _buildActivityCard(
          icon: Icons.folder_open,
          title: 'Arsip Diperbarui',
          subtitle: 'Dokumen bulan Oktober telah diarsipkan',
          time: '1 jam yang lalu',
          color: Colors.purple,
        ),
        _buildActivityCard(
          icon: Icons.event,
          title: 'Rapat Dijadwalkan',
          subtitle: 'Rapat koordinasi RW-RT, Jumat 17 Nov pukul 19:00',
          time: '2 jam yang lalu',
          color: Colors.orange,
        ),
        _buildActivityCard(
          icon: Icons.mail,
          title: 'Surat Masuk',
          subtitle: 'Undangan dari Kelurahan Tegalharjo',
          time: '3 jam yang lalu',
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildUpcomingMeetings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            Icons.event_note,
            'Rapat Mendatang',
            Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildMeetingItem(
            'Rapat Koordinasi RT-RW',
            'Jumat, 17 Nov 2023 • 19:00 WIB',
            'Balai RW 05',
            Colors.purple,
          ),
          const Divider(height: 24),
          _buildMeetingItem(
            'Evaluasi Program RW',
            'Senin, 20 Nov 2023 • 19:30 WIB',
            'Balai RW 05',
            Colors.blue,
          ),
          const Divider(height: 24),
          _buildMeetingItem(
            'Rapat Iuran Bulanan',
            'Rabu, 22 Nov 2023 • 20:00 WIB',
            'Balai RW 05',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            Icons.assessment,
            'Statistik Dokumen Bulan Ini',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatisticItem(
                'Total',
                '48',
                Icons.description,
                Colors.blue,
              ),
              _verticalDivider(),
              _buildStatisticItem(
                'Diproses',
                '32',
                Icons.pending_actions,
                Colors.orange,
              ),
              _verticalDivider(),
              _buildStatisticItem(
                'Selesai',
                '14',
                Icons.check_circle,
                Colors.green,
              ),
              _verticalDivider(),
              _buildStatisticItem('Ditolak', '2', Icons.cancel, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  // ====================== WIDGET BUILDERS ======================

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
                  Icons.work_outline,
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
                      'Selamat datang kembali',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sekretaris RW 05',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.business_center, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Administrasi & Dokumentasi',
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
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
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
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String type,
    required int pending,
    required int approved,
    required int rejected,
    required IconData icon,
    required Color color,
  }) {
    final total = pending + approved + rejected;
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: $total dokumen bulan ini',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDocumentMetric(
                  'Pending',
                  pending.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDocumentMetric(
                  'Disetujui',
                  approved.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDocumentMetric(
                  'Ditolak',
                  rejected.toString(),
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard({
    required String title,
    required String requester,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
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
                      requester,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Setujui'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text('Tinjau'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
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
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
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
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(
    String title,
    String datetime,
    String location,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
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
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    datetime,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildStatisticItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _verticalDivider() =>
      Container(width: 1, height: 40, color: Colors.grey[300]);

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
