import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class VerifikasiListPage extends StatelessWidget {
  const VerifikasiListPage({super.key});

  final List<Map<String, dynamic>> wargaPending = const [
    {
      'name': 'Budi Santoso',
      'nik': '3275010701010001',
      'alamat': 'Jl. Melati No. 12',
      'foto': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Siti Aminah',
      'nik': '3275011202020002',
      'alamat': 'Jl. Kenanga No. 5',
      'foto': 'https://i.pravatar.cc/150?img=2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Verifikasi Warga'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 96.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Warga Belum Diverifikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // ---- CARD LIST ----
              ...wargaPending.map((warga) {
                return _buildVerifikasiCard(
                  context,
                  name: warga['name'],
                  nik: warga['nik'],
                  alamat: warga['alamat'],
                  foto: warga['foto'],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifikasiCard(
    BuildContext context, {
    required String name,
    required String nik,
    required String alamat,
    required String foto,
  }) {
    return InkWell(
      onTap: () {
        context.push(
          '/admin/verifikasi/detail',
          extra: {'name': name, 'nik': nik, 'alamat': alamat, 'foto': foto},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            // Foto/Avatar — disamakan style dengan WargaListPage
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 26,
              ),
            ),

            const SizedBox(width: 16),

            // Informasi Warga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIK: $nik',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alamat,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),

                  // Badge status — disamakan style dengan WargaListPage
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Belum Diverifikasi',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
