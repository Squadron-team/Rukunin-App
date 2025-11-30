import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/pengumuman/pengumuman_card.dart';
import 'package:rukunin/pages/rw/pengumuman/pengumuman_detail.dart';

class PengumumanScreen extends StatelessWidget {
  const PengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final List<Map<String, String>> data = [
      {
        'judul': 'Kerja Bakti Mingguan',
        'tanggal': '20 November 2025',
        'isi': 'Warga dimohon hadir kerja bakti membersihkan lingkungan RT/RW.',
      },
      {
        'judul': 'Rapat RW Bulanan',
        'tanggal': '18 November 2025',
        'isi': 'Rapat rutin bulanan RW akan diadakan di balai warga.',
      },
      {
        'judul': 'Pendistribusian Sembako',
        'tanggal': '15 November 2025',
        'isi': 'Pembagian bantuan sembako untuk warga yang membutuhkan.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengumuman RW',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      backgroundColor: Colors.grey[50],

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          return PengumumanCard(
            judul: item['judul']!,
            tanggal: item['tanggal']!,
            isi: item['isi']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengumumanDetail(
                    judul: item['judul']!,
                    tanggal: item['tanggal']!,
                    isi: item['isi']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
