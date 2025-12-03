import 'package:flutter/material.dart';

class EmptyOutgoingMail extends StatelessWidget {
  const EmptyOutgoingMail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.send, size: 80, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Belum ada surat keluar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Silakan tambah surat baru.'),
        ],
      ),
    );
  }
}
