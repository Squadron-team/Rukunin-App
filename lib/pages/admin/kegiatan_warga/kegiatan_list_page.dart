import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class KegiatanListPage extends StatelessWidget {
  const KegiatanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Kegiatan Warga'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Kegiatan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // ======= SAMPLE DATA =======
            _cardItem(
              context,
              judul: 'Kerja Bakti Mingguan',
              tanggal: '10 Feb 2025',
              ringkasan: 'Membersihkan area taman dan saluran air.',
            ),

            _cardItem(
              context,
              judul: 'Posyandu Bulan Februari',
              tanggal: '7 Feb 2025',
              ringkasan: 'Pemeriksaan balita & lansia rutin.',
            ),

            _cardItem(
              context,
              judul: 'Ronda Malam',
              tanggal: '1 Feb 2025',
              ringkasan: 'Jadwal ronda untuk warga RT 03.',
            ),
          ],
        ),
      ),

      // =========== BUTTON ADD ===========
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.push('/admin/kegiatan/add'),
      ),
    );
  }

  // ========= CARD ITEM METHOD ==========
  Widget _cardItem(
    BuildContext context, {
    required String judul,
    required String tanggal,
    required String ringkasan,
  }) {
    return InkWell(
      onTap: () {
        context.push(
          '/admin/kegiatan/detail',
          extra: {'judul': judul, 'tanggal': tanggal, 'ringkasan': ringkasan},
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
            // ICON
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.event_note,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),

            // TEXT INFO
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
                  Text(
                    tanggal,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
