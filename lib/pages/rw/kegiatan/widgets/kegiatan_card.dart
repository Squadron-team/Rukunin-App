import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/kegiatan/models/kegiatan.dart';

class KegiatanCard extends StatelessWidget {
  final Kegiatan kegiatan;
  final VoidCallback? onDaftar;

  const KegiatanCard({
    required this.kegiatan, super.key,
    this.onDaftar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kegiatan.color.withOpacity(0.25), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildBody(context),
        ],
      ),
    );
  }

  // ================================
  // HEADER CARD
  // ================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            kegiatan.color.withOpacity(0.12),
            kegiatan.color.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kegiatan.color.withOpacity(0.28),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(kegiatan.iconUrl, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),

          // NAMA & KATEGORI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kegiatan.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kegiatan.color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    kegiatan.kategori,
                    style: TextStyle(
                      color: kegiatan.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // STATUS BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kegiatan.status == 'Akan Datang'
                  ? Colors.blue
                  : kegiatan.status == 'Sedang Berlangsung'
                      ? Colors.green
                      : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              kegiatan.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // BODY CARD
  // ================================
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DESKRIPSI
          Text(
            kegiatan.deskripsi,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          _info(Icons.calendar_today,
              '${kegiatan.tanggal.day}/${kegiatan.tanggal.month}/${kegiatan.tanggal.year}'),
          const SizedBox(height: 10),
          _info(Icons.access_time, kegiatan.waktu),
          const SizedBox(height: 10),
          _info(Icons.location_on, kegiatan.lokasi),
          const SizedBox(height: 10),
          _info(Icons.person, kegiatan.penyelenggara),

          const SizedBox(height: 16),

          // PROGRESS PESERTA
          _buildProgress(),

          const SizedBox(height: 14),

          // BUTTON DAFTAR
          if (kegiatan.status != 'Selesai')
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kegiatan.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: onDaftar ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mendaftar ke: ${kegiatan.nama}'),
                          backgroundColor: kegiatan.color,
                        ),
                      );
                    },
                icon: const Icon(Icons.app_registration, size: 18),
                label: const Text(
                  'Daftar Kegiatan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================================
  // INFO ROW
  // ================================
  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kegiatan.color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ================================
  // PROGRESS
  // ================================
  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kegiatan.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: 18, color: kegiatan.color),
                  const SizedBox(width: 6),
                  const Text(
                    'Peserta Terdaftar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                '${kegiatan.peserta}/${kegiatan.kuota}',
                style: TextStyle(
                  color: kegiatan.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: kegiatan.peserta / kegiatan.kuota,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(kegiatan.color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
