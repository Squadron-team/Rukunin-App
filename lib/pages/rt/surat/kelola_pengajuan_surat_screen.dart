import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class KelolaPengajuanSuratScreen extends StatelessWidget {
  const KelolaPengajuanSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Kelola Pengajuan Surat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Halaman Kelola Pengajuan Surat (belum diimplementasikan)'),
      ),
    );
  }
}
