import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/surat_form_warga/models/document_request.dart';
import 'package:rukunin/style/app_colors.dart';
import 'widgets/header_info.dart';
import 'widgets/attachments_list.dart';
import 'widgets/admin_note_upload.dart';
import 'widgets/action_buttons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class RequestDetailPage extends StatefulWidget {
  final DocumentRequest request;
  final Future<void> Function(String note)? onSaveNote;
  final Future<void> Function(String status)? onChangeStatus;

  const RequestDetailPage({
    required this.request,
    super.key,
    this.onSaveNote,
    this.onChangeStatus,
  });

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ukuran file maksimal 5MB'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ukuran file maksimal 5MB'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            return;
          }
          setState(() => _adminAttachments.add(image));
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _removeAdminAttachment(int index) {
    setState(() => _adminAttachments.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lampiran dihapus'),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<Widget> _buildAdminImageWidget(XFile file) async {
    final bytes = await file.readAsBytes();
    return Image.memory(bytes, fit: BoxFit.cover, width: 100, height: 100);
  }

  Future<void> _changeStatus(String status) async {
    final confirm = await showDialog<bool>(
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
                    status == 'diterima' ? Icons.check_circle : Icons.cancel,
                    size: 96,
                    color: status == 'diterima'
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    status == 'diterima'
                        ? 'Setujui pengajuan'
                        : 'Tolak pengajuan',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status == 'diterima'
                        ? 'Yakin ingin menyetujui pengajuan ini?'
                        : 'Yakin ingin menolak pengajuan ini?',
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
                          backgroundColor: status == 'diterima'
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        onPressed: () => Navigator.pop(c, true),
                        child: Text(
                          status == 'diterima' ? 'Setujui' : 'Tolak',
                          style: const TextStyle(color: Colors.white),
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
    if (confirm != true) return;
    await widget.onSaveNote?.call(_noteCtrl.text.trim());
    await widget.onChangeStatus?.call(status);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isFinal =
        widget.request.status == 'diterima' ||
        widget.request.status == 'ditolak';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.request.type == 'sktm' ? 'SKTM' : widget.request.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
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
              // header + info
              RequestHeaderInfo(request: widget.request, catColor: catColor, relativeTime: relativeTime),
              const SizedBox(height: 12),
              if (widget.request.attachments != null && widget.request.attachments!.isNotEmpty) ...[
                AttachmentsList(attachments: widget.request.attachments!, onDownload: (path) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fungsi unduh belum tersedia: $path'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
                }),
                const SizedBox(height: 12),
              ],

              // note + upload
              AdminNoteUpload(
                noteController: _noteCtrl,
                adminAttachments: _adminAttachments,
                buildImageWidget: _buildAdminImageWidget,
                onPick: _pickAdminImage,
                onRemove: _removeAdminAttachment,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RequestActionButtons(
        disabled: isFinal,
        onReject: () => _changeStatus('ditolak'),
        onAccept: () => _changeStatus('diterima'),
      ),
    );
  }
}
