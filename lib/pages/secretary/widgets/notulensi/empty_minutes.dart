import 'package:flutter/material.dart';

class EmptyMinutes extends StatelessWidget {
  const EmptyMinutes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.record_voice_over, size: 85, color: Colors.teal),
          SizedBox(height: 16),
          Text(
            'Belum ada notulensi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Klik tombol + untuk membuat notulensi baru'),
        ],
      ),
    );
  }
}
