import 'package:flutter/material.dart';

class ResidentsDataScreen extends StatelessWidget {
  const ResidentsDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Warga'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Data Warga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman untuk mengelola data warga'),
          ],
        ),
      ),
    );
  }
}
