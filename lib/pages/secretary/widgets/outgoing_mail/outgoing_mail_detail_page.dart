import 'package:flutter/material.dart';

class OutgoingMailDetailPage extends StatelessWidget {
  final String title;
  final String date;

  const OutgoingMailDetailPage({
    required this.title,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Surat Keluar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Judul Surat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            const Text(
              'Tanggal Surat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(date, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            const Text(
              'Deskripsi / Isi Surat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              'Ini adalah contoh isi surat keluar. Kamu bisa menggantinya sesuai kebutuhan '
              'atau mengambil dari database Laravel.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
