import 'package:flutter/material.dart';

class PengumumanDetail extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String isi;

  const PengumumanDetail({
    required this.judul,
    required this.tanggal,
    required this.isi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(tanggal, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Text(isi, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
