import 'package:flutter/material.dart';

class ResidentsDataScreen extends StatelessWidget {
  const ResidentsDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Warga')),
      body: const Center(
        child: Text(
          'Halaman Data Warga Belum Dibuat',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
