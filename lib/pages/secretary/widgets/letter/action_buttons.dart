import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPreview;
  final VoidCallback onCreate;

  const ActionButtons({
    super.key,
    required this.onPreview,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onCreate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text(
            "Buat Surat",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: onPreview,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: Icon(Icons.remove_red_eye, color: AppColors.primary),
          label: Text(
            "Preview Surat",
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
