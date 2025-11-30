import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.info_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Pastikan data sudah benar sebelum melanjutkan.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
