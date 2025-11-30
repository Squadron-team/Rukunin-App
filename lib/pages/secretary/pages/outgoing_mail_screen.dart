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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Surat Keluar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Halaman untuk mengelola surat keluar'),
          ],
        ),
      ),
    );
  }
}
