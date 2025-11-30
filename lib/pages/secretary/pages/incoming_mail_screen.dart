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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Surat Masuk',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman untuk mengelola surat masuk'),
          ],
        ),
      ),
    );
  }
}
