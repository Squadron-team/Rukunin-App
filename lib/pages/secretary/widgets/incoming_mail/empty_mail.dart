import 'package:flutter/material.dart';

class EmptyMail extends StatelessWidget {
  const EmptyMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, size: 90, color: Colors.blue.shade400),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Surat Masuk',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Silakan tambahkan surat masuk',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
