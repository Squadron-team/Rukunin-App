import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/community_head/warga/warga_edit_screen.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaDetailScreen extends StatelessWidget {
  final Warga warga;

  const WargaDetailScreen({required this.warga, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Warga'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(warga.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${warga.address} • RT ${warga.rt}/RW ${warga.rw}', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: warga.isActive ? AppColors.primary.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(warga.isActive ? 'Aktif' : 'Non-aktif', style: TextStyle(color: warga.isActive ? AppColors.primary : Colors.red[700])),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Informasi', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _infoRow('NIK', warga.nik),
            _infoRow('No. KK', warga.kkNumber),
            _infoRow('Tanggal Terdaftar', warga.createdAt.toLocal().toString().split(' ').first),
            const SizedBox(height: 16),
            const Text('Dokumen', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                _docTile(context, 'KTP', warga.ktpUrl),
                const SizedBox(width: 12),
                _docTile(context, 'KK', warga.kkUrl),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => WargaEditScreen(warga: warga)));
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Perubahan berhasil disimpan'),
                          backgroundColor: Colors.yellow[700],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      }
                    },
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Unduh laporan berhasil'),
                          backgroundColor: Colors.yellow[700],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      child: const Text('Unduh', style: TextStyle(color: Colors.white)),
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: TextStyle(color: Colors.grey[700]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _docTile(BuildContext context, String title, String url) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Center(child: Text(url.isEmpty ? 'Belum ada $title' : 'Preview $title')),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Upload $title berhasil'),
                    backgroundColor: Colors.yellow[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: const Text('Upload'),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: () {}, child: const Text('Lihat')),
            ],
          ),
        ],
      ),
    );
  }
}
