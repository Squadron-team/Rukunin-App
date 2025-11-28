import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminNoteUpload extends StatelessWidget {
  final TextEditingController noteController;
  final List<XFile> adminAttachments;
  final Future<Widget> Function(XFile file) buildImageWidget;
  final VoidCallback onPick;
  final void Function(int index) onRemove;

  const AdminNoteUpload({required this.noteController, required this.adminAttachments, required this.buildImageWidget, required this.onPick, required this.onRemove, super.key});

  Widget _buildPreview(int index) {
    final file = adminAttachments[index];
    return FutureBuilder<Widget>(
      future: buildImageWidget(file),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(width: 100, height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!), color: Colors.grey[100]), child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
        }
        return Stack(children: [
          Container(width: 100, height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)), clipBehavior: Clip.antiAlias, child: snapshot.data ?? const Icon(Icons.error)),
          Positioned(top: 4, right: 4, child: GestureDetector(onTap: () => onRemove(index), child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.close, size: 14, color: Colors.white)))),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 12),
      const Text('Kirim Catatan & Lampiran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
      const SizedBox(height: 8),
      TextField(controller: noteController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Catatan untuk pemohon (opsional)'), maxLines: 4),
      const SizedBox(height: 12),
      if (adminAttachments.isNotEmpty) ...[
        Wrap(spacing: 8, runSpacing: 8, children: List.generate(adminAttachments.length, (index) => _buildPreview(index))),
        const SizedBox(height: 12),
      ],
      GestureDetector(
        onTap: onPick,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload, size: 36, color: Colors.grey),
                const SizedBox(height: 10),
                const Text('Tambah Lampiran Catatan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Pilih foto atau dokumen (maks 5MB)', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
    ]);
  }
}
