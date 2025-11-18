import 'package:flutter/material.dart';

class RapatRwDetail extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String agenda;

  const RapatRwDetail({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.agenda,
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
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(tanggal),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(waktu),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(lokasi),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Agenda Rapat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              agenda,
              style: const TextStyle(fontSize: 16, height: 1.5),
            )
          ],
        ),
      ),
    );
  }
}
