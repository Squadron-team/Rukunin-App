import 'package:flutter/material.dart';

class IuranHeader extends StatelessWidget {
  final int totalWarga;
  final int sudahBayar;
  final int belumBayar;

  const IuranHeader({
    required this.totalWarga, required this.sudahBayar, required this.belumBayar, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekapitulasi Iuran RW',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRekapItem('Total Warga', totalWarga.toString()),
                _buildRekapItem('Sudah Bayar', sudahBayar.toString()),
                _buildRekapItem('Belum Bayar', belumBayar.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRekapItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
