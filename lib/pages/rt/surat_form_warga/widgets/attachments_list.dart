import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class AttachmentsList extends StatelessWidget {
  final List<String> attachments;
  final void Function(String path) onDownload;

  const AttachmentsList({
    required this.attachments,
    required this.onDownload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Lampiran Pemohon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: attachments.map((a) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.attachment, color: AppColors.primary),
                title: Text(a),
                trailing: IconButton(
                  icon: const Icon(Icons.download, color: AppColors.primary),
                  onPressed: () => onDownload(a),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
