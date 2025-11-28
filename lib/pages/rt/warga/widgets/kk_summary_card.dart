import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/widgets/family_status_editor.dart';
import 'package:rukunin/pages/rt/warga/widgets/info_row.dart';

class KkSummaryCard extends StatelessWidget {
  final String kkNumber;
  final String headOfFamily;
  final List<Warga> members;
  final String familyStatus;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback? onViewKk;

  const KkSummaryCard({
    required this.kkNumber,
    required this.headOfFamily,
    required this.members,
    required this.familyStatus,
    required this.onStatusChanged,
    this.onViewKk,
    super.key,
  });

  Widget _buildKkThumbnail() {
    final url = members.isNotEmpty ? members.first.kkUrl : '';
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          url,
          width: 84,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            width: 84,
            height: 56,
            color: Colors.grey[100],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      );
    }
    return Container(
      width: 84,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Kartu Keluarga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Informasi Lengkap Keluarga',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          InfoRow(label: 'No. Kartu Keluarga', value: kkNumber, isHighlight: true),
          const SizedBox(height: 12),
          InfoRow(label: 'Kepala Keluarga', value: headOfFamily),
          const SizedBox(height: 12),
          FamilyStatusEditor(status: familyStatus, onChanged: onStatusChanged),
          const SizedBox(height: 12),
          InfoRow(label: 'Jumlah Anggota', value: '${members.length} orang'),
          const SizedBox(height: 12),
          if (members.isNotEmpty)
            Row(
              children: [
                _buildKkThumbnail(),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.visibility, color: Colors.white),
                  label: const Text(
                    'Lihat KK',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onViewKk,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
