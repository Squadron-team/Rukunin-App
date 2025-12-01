import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_edit_screen.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_tile.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_preview_dialog.dart';
import 'package:rukunin/theme/app_colors.dart';

class WargaDetailScreen extends StatelessWidget {
  final Warga warga;

  const WargaDetailScreen({required this.warga, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Warga',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            warga.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${warga.address} • RT ${warga.rt}/RW ${warga.rw}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: warga.isActive
                              ? AppColors.primary.withOpacity(0.12)
                              : Colors.red.withOpacity(0.12),
                        ),
                      ),
                      child: Text(
                        warga.isActive ? 'Aktif' : 'Non-aktif',
                        style: TextStyle(
                          color: warga.isActive
                              ? AppColors.primary
                              : Colors.red[700],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Informasi',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                _infoRow('NIK', warga.nik),
                _infoRow('No. KK', warga.kkNumber),
                _infoRow(
                  'Tanggal Terdaftar',
                  warga.createdAt.toLocal().toString().split(' ').first,
                ),
                _infoRow('Peran', warga.isHead ? 'Kepala Keluarga' : 'Anggota'),
                _infoRow(
                  'Jenis Kelamin',
                  warga.gender.isNotEmpty ? warga.gender : '-',
                ),
                _infoRow('Status Kehidupan', warga.isAlive ? 'Hidup' : 'Wafat'),
                _infoRow(
                  'Tempat Lahir',
                  warga.placeOfBirth.isNotEmpty ? warga.placeOfBirth : '-',
                ),
                _infoRow(
                  'Tanggal Lahir',
                  warga.dateOfBirth != null
                      ? warga.dateOfBirth!.toLocal().toString().split(' ').first
                      : '-',
                ),
                _infoRow(
                  'Pekerjaan',
                  warga.pekerjaan.isNotEmpty ? warga.pekerjaan : '-',
                ),
                _infoRow(
                  'Status Perkawinan',
                  warga.maritalStatus.isNotEmpty ? warga.maritalStatus : '-',
                ),
                _infoRow(
                  'Pendidikan',
                  warga.education.isNotEmpty ? warga.education : '-',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dokumen',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DocTile(
                        title: 'KTP',
                        url: warga.ktpUrl,
                        onUpload: () {},
                        onView: () => showDocPreview(
                          context,
                          type: 'KTP',
                          name: warga.name,
                          number: warga.nik,
                          url: warga.ktpUrl,
                        ),
                        showUpload: false,
                        showViewButton: false,
                        viewOnBoxTap: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DocTile(
                        title: 'KK',
                        url: warga.kkUrl,
                        onUpload: () {},
                        onView: () => showDocPreview(
                          context,
                          type: 'KK',
                          name: warga.name,
                          number: warga.kkNumber,
                          url: warga.kkUrl,
                        ),
                        showUpload: false,
                        showViewButton: false,
                        viewOnBoxTap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Unduh laporan berhasil'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.file_download_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Unduh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Floating edit button
          Positioned(
            right: 8,
            bottom: 24,
            child: FloatingActionButton(
              heroTag: 'edit-warga',
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WargaEditScreen(warga: warga),
                  ),
                );
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Perubahan berhasil disimpan'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
