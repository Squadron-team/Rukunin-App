import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Komunitas'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Informasi Komunitas'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.people,
            title: 'Informasi Kependudukan',
            subtitle: 'Lihat data KTP/KK Anda',
            onTap: () => context.push('/resident/community/population'),
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.family_restroom,
            title: 'Data Keluarga (KK)',
            subtitle: 'Kelola informasi anggota keluarga',
            onTap: () => context.push('/resident/community/family'),
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.home,
            title: 'Data Rumah',
            subtitle: 'Kelola informasi tempat tinggal Anda',
            onTap: () => context.push('/resident/community/home'),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Keuangan & Iuran'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.account_balance_wallet,
            title: 'Iuran Saya',
            subtitle: 'Riwayat pembayaran iuran bulanan',
            onTap: () => context.push('/resident/community/dues'),
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.trending_up,
            title: 'Transparansi Keuangan',
            subtitle: 'Laporan keuangan RT/RW',
            onTap: () =>
                context.push('/resident/community/finance-transparency'),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Administrasi'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.description,
            title: 'Pengajuan Surat',
            subtitle: 'Ajukan surat keterangan dan dokumen',
            onTap: () => context.push('/resident/community/documents'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
