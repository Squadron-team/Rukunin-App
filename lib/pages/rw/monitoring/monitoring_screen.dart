import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text('Monitoring RW'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summaryCard(),
          const SizedBox(height: 16),
          _monitoringItem(
            icon: Icons.groups,
            title: 'Data Warga',
            subtitle: 'Update terakhir: hari ini',
            status: 'Aktif',
            color: Colors.green,
          ),
          _monitoringItem(
            icon: Icons.event,
            title: 'Kegiatan',
            subtitle: 'Belum ada update',
            status: 'Perlu Update',
            color: Colors.orange,
          ),
          _monitoringItem(
            icon: Icons.report,
            title: 'Laporan Warga',
            subtitle: '2 laporan belum ditangani',
            status: 'Perhatian',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // =============================
  // SUMMARY
  // =============================
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Monitoring',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pantau aktivitas dan laporan RW secara realtime',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // =============================
  // ITEM
  // =============================
  Widget _monitoringItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Chip(
          label: Text(status, style: TextStyle(color: color, fontSize: 12)),
          backgroundColor: color.withOpacity(0.1),
        ),
      ),
    );
  }
}
