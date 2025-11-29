import 'package:flutter/material.dart';

class PemasukanHeader extends StatelessWidget {
  const PemasukanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Catat Pemasukan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Lengkapi formulir di bawah untuk mencatat pemasukan ke kas RW',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
