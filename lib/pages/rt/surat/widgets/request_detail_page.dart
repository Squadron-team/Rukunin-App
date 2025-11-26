import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/surat/models/document_request.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
// import 'package:rukunin/repositories/document_requests_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class RequestDetailPage extends StatefulWidget {
  final DocumentRequest request;
  final Future<void> Function(String note)? onSaveNote;
  final Future<void> Function(String status)? onChangeStatus;

  const RequestDetailPage({Key? key, required this.request, this.onSaveNote, this.onChangeStatus}) : super(key: key);

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  final TextEditingController _noteCtrl = TextEditingController();
  final List<XFile> _adminAttachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _noteCtrl.text = widget.request.adminNote ?? '';
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAdminImage() async {
    try {
      if (kIsWeb) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          if (bytes.length > 5 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Ukuran file maksimal 5MB'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }
            return;
          }
          setState(() => _adminAttachments.add(image));
        }
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          if (bytes.length > 5 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Ukuran file maksimal 5MB'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }
            return;
          }
          setState(() => _adminAttachments.add(image));
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }

  void _removeAdminAttachment(int index) {
    setState(() => _adminAttachments.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Lampiran dihapus'),
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<Widget> _buildAdminImageWidget(XFile file) async {
    final bytes = await file.readAsBytes();
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
    );
  }

  Widget _buildAdminAttachmentPreview(int index) {
    return FutureBuilder<Widget>(
      future: _buildAdminImageWidget(_adminAttachments[index]),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
              clipBehavior: Clip.antiAlias,
              child: snapshot.data ?? const Icon(Icons.error),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeAdminAttachment(index),
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


  Future<void> _changeStatus(String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status == 'diterima' ? Icons.check_circle : Icons.cancel,
                    size: 96,
                    color: status == 'diterima' ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    status == 'diterima' ? 'Setujui pengajuan' : 'Tolak pengajuan',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status == 'diterima' ? 'Yakin ingin menyetujui pengajuan ini?' : 'Yakin ingin menolak pengajuan ini?',
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
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(c, false),
                        child: Text('Batal', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: status == 'diterima' ? AppColors.success : AppColors.error),
                        onPressed: () => Navigator.pop(c, true),
                        child: Text(status == 'diterima' ? 'Setujui' : 'Tolak', style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    if (confirm != true) return;
    // save current note first (if any), then change status
    await widget.onSaveNote?.call(_noteCtrl.text.trim());
    await widget.onChangeStatus?.call(status);
    if (mounted) Navigator.pop(context);
  }

  // (old icon+title+subtitle helper removed; we use label/value rows instead)

  Widget _buildInfoRowLabel(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: isHighlight ? AppColors.primary : Colors.black, fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFinal = widget.request.status == 'diterima' || widget.request.status == 'ditolak';

    Color categoryColor(String t) {
      switch (t) {
        case 'domicile':
          return Colors.blue;
        case 'sktm':
          return Colors.orange;
        case 'business':
          return Colors.green;
        case 'correction':
          return Colors.purple;
        case 'family':
          return Colors.teal;
        default:
          return Colors.grey;
      }
    }

    String relativeTime(DateTime dt) {
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} menit yang lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
      return '${diff.inDays} hari yang lalu';
    }

    final catColor = categoryColor(widget.request.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.request.type == 'sktm' ? 'SKTM' : widget.request.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card: colored header (icon/title/subtitle) and white info area below
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [catColor.withOpacity(0.20), catColor.withOpacity(0.06)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      border: Border.all(color: catColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: catColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: catColor.withOpacity(0.25), blurRadius: 8, offset: const Offset(0,4))],
                          ),
                          child: const Icon(Icons.description, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.request.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
                              const SizedBox(height: 6),
                              Text('Informasi Pengajuan', style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                      border: Border.all(color: catColor.withOpacity(0.18)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          _buildInfoRowLabel('Pemohon', widget.request.requester),
                        const SizedBox(height: 12),
                        _buildInfoRowLabel('Tujuan', widget.request.purpose),
                        const SizedBox(height: 12),
                        _buildInfoRowLabel('Dikirim', relativeTime(widget.request.createdAt.toLocal())),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Resident-submitted attachments: show right below information
              if (widget.request.attachments != null && widget.request.attachments!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Lampiran Pemohon', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Column(
                        children: widget.request.attachments!.map((a) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.attachment, color: AppColors.primary),
                              title: Text(a),
                              trailing: IconButton(
                                icon: const Icon(Icons.download, color: AppColors.primary),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Fungsi unduh belum tersedia: $a'),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ));
                                },
                              ),
                            )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Header for admin note & attachments
              const SizedBox(height: 12),
              Text('Kirim Catatan & Lampiran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 8),
              // Note field
              TextField(
                controller: _noteCtrl,
                decoration: buildInputDecoration('Catatan untuk pemohon (opsional)'),
                maxLines: 4,
              ),
              const SizedBox(height: 12),

              // Admin attachments: inline uploader with previews (like community form)
              if (_adminAttachments.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_adminAttachments.length, (index) => _buildAdminAttachmentPreview(index)),
                ),
                const SizedBox(height: 12),
              ],

              GestureDetector(
                onTap: _pickAdminImage,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.cloud_upload, size: 36, color: AppColors.primary),
                        const SizedBox(height: 10),
                        Text('Tambah Lampiran Catatan', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Pilih foto atau dokumen (maks 5MB)', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isFinal ? null : () => _changeStatus('ditolak'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                  child: const Text('Tolak'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isFinal ? null : () => _changeStatus('diterima'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                  child: const Text('Setuju'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
