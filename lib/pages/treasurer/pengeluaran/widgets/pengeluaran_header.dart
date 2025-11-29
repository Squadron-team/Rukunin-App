import 'package:flutter/material.dart';

class PengeluaranHeader extends StatelessWidget {
  const PengeluaranHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Catat Pengeluaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Lengkapi formulir di bawah untuk mencatat pengeluaran RW',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
