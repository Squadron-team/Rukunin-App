import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rukunin/theme/app_colors.dart';

Future<void> showCsvPreview(BuildContext context, String csv) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Preview CSV',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: csv));
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('CSV disalin ke clipboard'),
                        ),
                      );
                    },
                    child: const Text('Salin'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: SelectableText(
                    csv,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
