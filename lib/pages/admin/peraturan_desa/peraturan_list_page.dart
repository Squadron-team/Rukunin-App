import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class PeraturanListPage extends StatelessWidget {
  const PeraturanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Peraturan Desa'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Peraturan Desa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            _cardItem(
              context,
              judul: 'Peraturan Ketertiban dan Keamanan',
              tanggal: '15 Jan 2025',
              kategori: 'Ketertiban',
              ringkasan:
                  'Aturan tentang ketertiban dan keamanan lingkungan desa.',
            ),

            _cardItem(
              context,
              judul: 'Peraturan Pengelolaan Sampah',
              tanggal: '20 Des 2024',
              kategori: 'Kebersihan',
              ringkasan:
                  'Tata cara pembuangan dan pengelolaan sampah rumah tangga.',
            ),

            _cardItem(
              context,
              judul: 'Peraturan Iuran Warga',
              tanggal: '10 Des 2024',
              kategori: 'Keuangan',
              ringkasan:
                  'Ketentuan iuran bulanan dan penggunaannya untuk kepentingan bersama.',
            ),

            _cardItem(
              context,
              judul: 'Peraturan Penggunaan Fasilitas Umum',
              tanggal: '5 Nov 2024',
              kategori: 'Fasilitas',
              ringkasan:
                  'Tata tertib penggunaan balai desa dan fasilitas umum lainnya.',
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.push('/admin/village-rules/add'),
      ),
    );
  }

  Widget _cardItem(
    BuildContext context, {
    required String judul,
    required String tanggal,
    required String kategori,
    required String ringkasan,
  }) {
    return InkWell(
      onTap: () {
        context.push(
          '/admin/village-rules/detail',
          extra: {
            'judul': judul,
            'tanggal': tanggal,
            'kategori': kategori,
            'ringkasan': ringkasan,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.gavel,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          kategori,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tanggal,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ringkasan,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
