import 'package:flutter/material.dart';
import '../../../models/rt_letter.dart';
import 'package:image_picker/image_picker.dart';

class RtToRwLetterFormScreen extends StatefulWidget {
  final String typeKey;
  final String typeTitle;
  final Color color;
  final IconData icon;

  const RtToRwLetterFormScreen({
    required this.typeKey,
    required this.typeTitle,
    required this.color,
    required this.icon,
    super.key,
  });

  @override
  State<RtToRwLetterFormScreen> createState() => _RtToRwLetterFormScreenState();
}

class _RtToRwLetterFormScreenState extends State<RtToRwLetterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _purposeController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _attachments = [];

  @override
  void dispose() {
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final item = RtLetter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: widget.typeKey,
      title: widget.typeTitle,
      purpose: _purposeController.text.trim(),
    );

    RtLetterRepository.add(item);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Surat berhasil dibuat'),
          backgroundColor: widget.color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context, true);
    }

    setState(() => _isSubmitting = false);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ukuran file maksimal 5MB'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        return;
      }

      setState(() => _attachments.add(image));
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _removeAttachment(int index) {
    setState(() => _attachments.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lampiran dihapus'),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<Widget> _buildImageWidget(XFile file) async {
    final bytes = await file.readAsBytes();
    return Image.memory(bytes, fit: BoxFit.cover, width: 100, height: 100);
  }

  Widget _buildAttachmentPreview(int index) {
    return FutureBuilder<Widget>(
      future: _buildImageWidget(_attachments[index]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[100],
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              clipBehavior: Clip.antiAlias,
              child: snapshot.data ?? const Icon(Icons.error),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeAttachment(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.typeTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [widget.color.withOpacity(0.12), widget.color.withOpacity(0.05)]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.color.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(width: 56, height: 56, decoration: BoxDecoration(color: widget.color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Icon(widget.icon, color: widget.color, size: 28)),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.typeTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black))),
              ]),
            ),

            const SizedBox(height: 20),

            Text('Tujuan / Pokok Surat *', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
              child: TextFormField(
                controller: _purposeController,
                maxLines: 2,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tujuan harus diisi' : null,
                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16), hintText: 'Contoh: Permohonan pengesahan daftar peserta'),
              ),
            ),

            const SizedBox(height: 16),

            Text('Catatan / Keterangan', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
              child: TextFormField(controller: _notesController, maxLines: 4, decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16), hintText: 'Tambahkan informasi tambahan (opsional)')), 
            ),

            const SizedBox(height: 16),

            if (_attachments.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_attachments.length, (index) => _buildAttachmentPreview(index)),
              ),
              const SizedBox(height: 12),
            ],

            GestureDetector(
              onTap: _pickImage,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.color.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 36,
                        color: widget.color,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tambah Lampiran',
                        style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih foto atau dokumen (maks 5MB)',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: widget.color, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Kirim Surat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
