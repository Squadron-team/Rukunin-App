import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

enum ManualReviewResult { accept, reject }

class ManualReviewPage extends StatelessWidget {
  final Uint8List imageBytes;
  const ManualReviewPage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinjau Manual'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: InteractiveViewer(
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(ManualReviewResult.accept),
                        child: const Text('Catat Pengeluaran'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () => Navigator.of(context).pop(ManualReviewResult.reject),
                        child: const Text('Tolak Pengeluaran'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
