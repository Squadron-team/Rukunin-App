import 'package:flutter/material.dart';

class RapatRwCard extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final VoidCallback onTap;

  const RapatRwCard({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(tanggal, style: const TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(waktu, style: const TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(lokasi, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
