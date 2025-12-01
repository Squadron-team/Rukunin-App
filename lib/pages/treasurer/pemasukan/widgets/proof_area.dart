import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

/// A compact proof area widget used by the pemasukan form.
///
/// This widget intentionally avoids importing the parent enums to prevent
/// circular imports. Instead it accepts plain booleans and callbacks.
class ProofArea extends StatelessWidget {
  final bool isPhotoMode;
  final Uint8List? pickedBytes;
  final bool detectionRan;
  final bool hasDetections;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onRunDetection;
  final VoidCallback onClearImage;

  const ProofArea({
    required this.isPhotoMode,
    required this.pickedBytes,
    required this.detectionRan,
    required this.hasDetections,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRunDetection,
    required this.onClearImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPhotoMode) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('Tunai dipilih — tidak perlu mengunggah bukti.'),
        ),
      );
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bukti Foto'),
            const SizedBox(height: 8),
            if (pickedBytes == null)
              GestureDetector(
                onTap: onPickGallery,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_upload,
                          size: 36,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tambah Lampiran',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pilih foto atau dokumen (maks 5MB) atau gunakan kamera',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: onPickGallery,
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Galeri'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: onPickCamera,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Kamera'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        pickedBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: onClearImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (pickedBytes != null) ...[
              const SizedBox(height: 8),
              if (detectionRan)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    backgroundColor: hasDetections
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    label: Text(
                      hasDetections ? 'Hasil: ASLI' : 'Hasil: PALSU',
                      style: TextStyle(
                        color: hasDetections ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Jika mengunggah struk BNI, klik Deteksi untuk memeriksa keaslian',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onRunDetection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Deteksi'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
