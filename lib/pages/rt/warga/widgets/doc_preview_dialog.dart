import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

Future<void> showDocPreview(BuildContext context, {required String type, required String name, required String number, required String url}) {
  return showDialog(
    context: context,
    builder: (c) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              color: Colors.black,
              constraints: const BoxConstraints(maxHeight: 480),
              child: Image.asset(
                url,
                fit: BoxFit.contain,
                errorBuilder: (c2, e, s) => Container(
                  height: 240,
                  color: Colors.grey[100],
                  child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$type - $name', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(number, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: Colors.grey.shade400),
                        foregroundColor: Colors.grey[800],
                      ),
                      onPressed: () => Navigator.of(c).pop(),
                      child: const Text('Tutup'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.file_download_outlined, color: Colors.white),
                      label: const Text('Unduh', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(c).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Berhasil diunduh'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
