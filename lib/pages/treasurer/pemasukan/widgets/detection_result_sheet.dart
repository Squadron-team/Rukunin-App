import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

typedef VoidCallbackNoArgs = void Function();

class DetectionResultSheet extends StatelessWidget {
  final String state; // "success", "warning", "error"
  final Uint8List? imageBytes;
  final VoidCallbackNoArgs onAccept;
  final VoidCallbackNoArgs onManualReview;
  final VoidCallbackNoArgs onReject;
  final VoidCallbackNoArgs onReupload;

  const DetectionResultSheet({
    Key? key,
    required this.state,
    required this.imageBytes,
    required this.onAccept,
    required this.onManualReview,
    required this.onReject,
    required this.onReupload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state == 'success') ...[
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade400,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Struk Terverifikasi',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Struk masuk dinyatakan valid berdasarkan hasil pengecekan sistem.'),
                const SizedBox(height: 16),
                if (imageBytes != null)
                  SizedBox(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(imageBytes!, fit: BoxFit.cover),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onAccept,
                    child: const Text('Catat sebagai Pemasukan'),
                  ),
                ),
              ] else if (state == 'warning') ...[
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade300,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Struk Mencurigakan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Sistem mendeteksi indikasi kejanggalan pada struk yang diunggah.'),
                const SizedBox(height: 16),
                if (imageBytes != null)
                  SizedBox(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(imageBytes!, fit: BoxFit.cover),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onManualReview,
                    child: const Text('Tinjau Manual'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: onReject,
                    child: const Text('Tolak Pemasukan'),
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade300, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Struk Tidak Dapat Dibaca',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Gambar blur atau resolusi rendah; ungah ulang struk dengan foto yang lebih jelas.'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onReupload,
                    child: const Text('Unggah Ulang'),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
