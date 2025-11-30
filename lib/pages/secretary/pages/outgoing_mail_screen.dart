import 'package:flutter/material.dart';

class OutgoingMailScreen extends StatelessWidget {
  const OutgoingMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Keluar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Surat Keluar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman untuk mengelola surat keluar'),
          ],
        ),
      ),
    );
  }
}
