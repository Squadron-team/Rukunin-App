import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/admin/warga/warga_edit_page.dart';

class WargaDetailPage extends StatelessWidget {
  final String name;
  final String nik;
  final String alamat;
  final String noTelp;
  final String status;

  const WargaDetailPage({
    super.key,
    required this.name,
    required this.nik,
    required this.alamat,
    required this.noTelp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Detail Warga',
      currentIndex: 0,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 650; // batas responsive

          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: isWide ? 650 : double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- GRID RESPONSIVE ----
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 2 : 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: isWide ? 1.8 : 2.5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _detailCard('Nama Lengkap', name),
                        _detailCard('NIK', nik),
                        _detailCard('Alamat', alamat),
                        _detailCard('No. Telepon', noTelp),
                        _detailCard('Status Warga', status),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ------- BUTTON EDIT -------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Data Warga',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => WargaEditPage(
                          //       name: name,
                          //       nik: nik,
                          //       alamat: alamat,
                          //       noTelp: noTelp,
                          //       status: status,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ====== WIDGET DETAIL CARD ======
  Widget _detailCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}