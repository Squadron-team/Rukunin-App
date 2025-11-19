import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';

// import halaman navigasi
import 'package:rukunin/pages/admin/warga/warga_detail_page.dart';
import 'package:rukunin/pages/admin/warga/warga_add_page.dart';

class WargaListPage extends StatelessWidget {
  const WargaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Data Warga',
      currentIndex: 0,
      // body menerima sebuah widget — kita gunakan Stack agar bisa overlay FAB
      body: Stack(
        children: [
          // Konten utama (scrollable)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 96.0),
              // tambahkan bottom padding agar konten tidak tertutup FAB
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Warga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildWargaCard(
                    context,
                    name: 'Budi Santoso',
                    nik: '3201012345678901',
                    alamat: 'Jl. Melati No. 12',
                    noTelp: '081234567890',
                    status: 'Aktif',
                  ),
                  _buildWargaCard(
                    context,
                    name: 'Siti Aminah',
                    nik: '3201012345678902',
                    alamat: 'Gang Mawar No. 5',
                    noTelp: '081234567891',
                    status: 'Aktif',
                  ),
                  _buildWargaCard(
                    context,
                    name: 'Rangga Saputra',
                    nik: '3201012345678903',
                    alamat: 'RT 02 / RW 01',
                    noTelp: '081234567892',
                    status: 'Nonaktif',
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button di pojok kanan bawah
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WargaAddPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Kartu Data Warga + Navigasi ke Detail Page
  // ---------------------------------------------------------------------------
  Widget _buildWargaCard(
    BuildContext context, {
    required String name,
    required String nik,
    required String alamat,
    required String noTelp,
    required String status,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WargaDetailPage(
              name: name,
              nik: nik,
              alamat: alamat,
              noTelp: noTelp,
              status: status,
            ),
          ),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 26),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        noTelp,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: status == 'Aktif'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            color: status == 'Aktif' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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