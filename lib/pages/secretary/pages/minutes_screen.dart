import 'package:flutter/material.dart';

class MinutesScreen extends StatelessWidget {
  const MinutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notulensi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.record_voice_over, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Notulensi Rapat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman untuk membuat notulensi rapat'),
          ],
        ),
      ),
    );
  }
}
