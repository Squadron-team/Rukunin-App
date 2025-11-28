import 'package:flutter/material.dart';

class SuratMenyuratScreen extends StatelessWidget {
  const SuratMenyuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surat Menyurat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[50],
      body: const Center(child: Text('Halaman Surat Menyurat')),
    );
  }
}
