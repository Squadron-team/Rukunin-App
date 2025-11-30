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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.record_voice_over, size: 80, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              'Notulensi Rapat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Halaman untuk membuat notulensi rapat'),
          ],
        ),
      ),
    );
  }
}
