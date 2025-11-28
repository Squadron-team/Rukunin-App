import 'package:flutter/material.dart';

class PengumumanScreen extends StatelessWidget {
  const PengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman')),
      body: const Center(child: Text('Halaman Pengumuman')),
    );
  }
}
