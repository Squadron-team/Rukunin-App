import 'package:flutter/material.dart';

class MeetingInvitationsScreen extends StatelessWidget {
  const MeetingInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> invitations = [
      {
        'title': 'Rapat Koordinasi Mingguan',
        'date': '10 Desember 2025',
        'time': '09:00 WIB',
        'place': 'Ruang Rapat Lantai 2',
      },
      {
        'title': 'Evaluasi Proyek Sistem Informasi',
        'date': '12 Desember 2025',
        'time': '13:00 WIB',
        'place': 'Meeting Room 1',
      },
      {
        'title': 'Undangan Presentasi Laporan',
        'date': '15 Desember 2025',
        'time': '10:30 WIB',
        'place': 'Aula Gedung A',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UNDANGAN RAPAT')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final item = invitations[index];
          return _buildInvitationCard(item);
        },
      ),
    );
  }

  Widget _buildInvitationCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title']!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(item['date']!),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.green),
              const SizedBox(width: 6),
              Text(item['time']!),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: 6),
              Text(item['place']!),
            ],
          ),
        ],
      ),
    );
  }
}
