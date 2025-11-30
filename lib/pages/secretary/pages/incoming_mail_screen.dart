import 'package:flutter/material.dart';

class IncomingMailScreen extends StatelessWidget {
  const IncomingMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Masuk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Surat Masuk',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Halaman untuk mengelola surat masuk'),
          ],
        ),
      ),
    );
  }
}
