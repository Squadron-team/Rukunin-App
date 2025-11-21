import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/onboarding/widgets/info_card.dart';
import 'package:rukunin/style/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lengkapi data kependudukan Anda untuk menggunakan aplikasi Rukunin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          const InfoCard(
            icon: Icons.badge,
            title: 'Data KTP',
            description: 'Informasi identitas diri berdasarkan Kartu Tanda Penduduk',
          ),
          const SizedBox(height: 16),
          const InfoCard(
            icon: Icons.family_restroom,
            title: 'Data Kartu Keluarga',
            description: 'Informasi keluarga berdasarkan Kartu Keluarga',
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Data yang Anda masukkan akan diverifikasi oleh pengurus RT/RW',
                    style: TextStyle(fontSize: 13, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
