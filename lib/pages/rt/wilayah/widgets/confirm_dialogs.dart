import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

Future<void> showCannotDeleteDialog(BuildContext context) async {
  await showDialog<bool>(
    context: context,
    builder: (c) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 96,
                  color: Colors.red.shade200,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tidak dapat menghapus',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Terdapat warga/keluarga yang terdaftar pada jalan ini. Hapus data warga terlebih dahulu.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () => Navigator.pop(c),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> showConfirmDeleteDialog(BuildContext context, String streetName) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 96,
                  color: Colors.red.shade200,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hapus jalan',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yakin menghapus $streetName?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.pop(c, false),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return ok;
}
