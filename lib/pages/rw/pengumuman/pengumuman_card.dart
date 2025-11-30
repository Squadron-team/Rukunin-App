import 'package:flutter/material.dart';

class PengumumanCard extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String isi;
  final VoidCallback onTap;

  const PengumumanCard({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.isi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
                  const SizedBox(width: 5),
                  Text(tanggal, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                isi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
