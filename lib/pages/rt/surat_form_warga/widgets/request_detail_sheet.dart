import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/surat_form_warga/models/document_request.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/widgets/loading_indicator.dart';

class RequestDetailSheet extends StatefulWidget {
  final DocumentRequest request;
  final Future<void> Function(String note)? onSaveNote;
  final Future<void> Function(String status)? onChangeStatus;

  const RequestDetailSheet({
    required this.request,
    super.key,
    this.onSaveNote,
    this.onChangeStatus,
  });

  @override
  State<RequestDetailSheet> createState() => _RequestDetailSheetState();
}

class _RequestDetailSheetState extends State<RequestDetailSheet> {
  final TextEditingController _noteCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _noteCtrl.text = widget.request.note ?? '';
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _saving = true);
    await widget.onSaveNote?.call(_noteCtrl.text.trim());
    setState(() => _saving = false);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _changeStatus(String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
          status == 'approved' ? 'Setujui pengajuan?' : 'Tolak pengajuan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await widget.onChangeStatus?.call(status);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isFinal =
        widget.request.status == 'approved' ||
        widget.request.status == 'rejected';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.request.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Pemohon: ${widget.request.requester}'),
            const SizedBox(height: 8),
            Text('Tujuan: ${widget.request.purpose}'),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              decoration: buildInputDecoration(
                'Catatan untuk pemohon (opsional)',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : _saveNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: LoadingIndicator(),
                          )
                        : const Text('Simpan Catatan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isFinal ? null : () => _changeStatus('approved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isFinal ? null : () => _changeStatus('rejected'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tolak'),
            ),
          ],
        ),
      ),
    );
  }
}
