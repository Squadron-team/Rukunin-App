import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class DownloadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const DownloadButton({
    required this.onPressed,
    super.key,
    this.label = 'Unduh',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.file_download_outlined,
        size: 18,
        color: Colors.white,
      ),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}
