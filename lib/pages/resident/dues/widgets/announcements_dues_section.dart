import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class AnnouncementsDuesSection extends StatelessWidget {
  const AnnouncementsDuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(26),
            AppColors.primary.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(39)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.campaign,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pengumuman Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnnouncementItem(
            'Perbaikan jalan gang 3 akan dilakukan pada tanggal 20 November 2025.',
            '2 hari lalu',
          ),
          const Divider(height: 24),
          _buildAnnouncementItem(
            'Reminder: Pembayaran iuran bulan November jatuh tempo 30 November 2025.',
            '5 hari lalu',
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to all announcements
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lihat Semua Pengumuman',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
        ),
        const SizedBox(height: 6),
        Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
