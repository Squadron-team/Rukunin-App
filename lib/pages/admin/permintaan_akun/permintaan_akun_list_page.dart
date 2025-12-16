import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class PermintaanAkunListPage extends StatelessWidget {
  const PermintaanAkunListPage({super.key});

  final List<Map<String, dynamic>> permintaanPending = const [
    {
      'name': 'Ahmad Rizki',
      'nik': '3275012301950001',
      'email': 'ahmad.rizki@email.com',
      'phone': '081234567890',
      'alamat': 'Jl. Merdeka No. 45',
      'foto': 'https://i.pravatar.cc/150?img=10',
      'tanggal': '15 Des 2025',
    },
    {
      'name': 'Dewi Lestari',
      'nik': '3275014505920002',
      'email': 'dewi.lestari@email.com',
      'phone': '082345678901',
      'alamat': 'Jl. Sudirman No. 78',
      'foto': 'https://i.pravatar.cc/150?img=20',
      'tanggal': '14 Des 2025',
    },
    {
      'name': 'Rudi Hartono',
      'nik': '3275016708880003',
      'email': 'rudi.hartono@email.com',
      'phone': '083456789012',
      'alamat': 'Jl. Gatot Subroto No. 23',
      'foto': 'https://i.pravatar.cc/150?img=30',
      'tanggal': '13 Des 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Permintaan Akun'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 96.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Permintaan Akun Baru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${permintaanPending.length} permintaan menunggu persetujuan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${permintaanPending.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card List
              ...permintaanPending.map((permintaan) {
                return _buildPermintaanCard(
                  context,
                  name: permintaan['name'],
                  nik: permintaan['nik'],
                  email: permintaan['email'],
                  phone: permintaan['phone'],
                  alamat: permintaan['alamat'],
                  foto: permintaan['foto'],
                  tanggal: permintaan['tanggal'],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermintaanCard(
    BuildContext context, {
    required String name,
    required String nik,
    required String email,
    required String phone,
    required String alamat,
    required String foto,
    required String tanggal,
  }) {
    return InkWell(
      onTap: () {
        context.push(
          '/admin/permintaan-akun/detail',
          extra: {
            'name': name,
            'nik': nik,
            'email': email,
            'phone': phone,
            'alamat': alamat,
            'foto': foto,
            'tanggal': tanggal,
          },
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
            // Foto/Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_add,
                color: AppColors.primary,
                size: 26,
              ),
            ),

            const SizedBox(width: 16),

            // Informasi Permintaan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        tanggal,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Badge status
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
                      'Menunggu Persetujuan',
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
