import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';

class DataIuranDetail extends StatefulWidget {
  final Map<String, String> item;
  const DataIuranDetail({super.key, required this.item});

  @override
  State<DataIuranDetail> createState() => _DataIuranDetailState();
}

class _DataIuranDetailState extends State<DataIuranDetail> {
  late bool _isAsli;
  final TextEditingController _rejectNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // read deterministic prediction from repository (dummy data)
    final id = widget.item['id'];
    final p = id == null ? null : DataIuranRepository().prediction(id);
    // if repository does not have a prediction, default to `true` (asli)
    _isAsli = p ?? true;
  }

  @override
  void dispose() {
    _rejectNoteCtrl.dispose();
    super.dispose();
  }

  void _accept() {
    final id = widget.item['id'];
    if (id != null) DataIuranRepository().verify(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Iuran diverifikasi'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _reject() async {
    _rejectNoteCtrl.text = '';
    final ok = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35,
          maxChildSize: 0.6,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  // plain input without the extra card background
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextFormField(
                      controller: _rejectNoteCtrl,
                      minLines: 3,
                      maxLines: 3,
                      decoration: buildInputDecoration('Alasan penolakan (opsional)'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[800],
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (ok == true) {
      final note = _rejectNoteCtrl.text.trim();
      final id = widget.item['id'];
      if (id != null) DataIuranRepository().reject(id, note.isEmpty ? null : note);
      final msg = note.isEmpty ? 'Iuran ditolak' : 'Iuran ditolak. Catatan dikirim';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Detail Iuran',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('${item['name'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 120, child: Text('Asal RT', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600))),
                        Expanded(child: Text(item['rt'] ?? '-')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 120, child: Text('Jenis Iuran', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600))),
                        Expanded(child: Text(item['type'] ?? '-')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 120, child: Text('Jumlah', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600))),
                        Expanded(
                          child: Text(
                            item['amount'] ?? '-',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text('Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              insetPadding: const EdgeInsets.all(16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                color: Colors.white,
                                child: const SizedBox(height: 300, child: Center(child: Icon(Icons.receipt_long, size: 120, color: Colors.grey))),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
                        child: const Center(child: Icon(Icons.receipt_long, size: 64, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Hasil Deteksi: ', style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            if (_isAsli == true) Text('Asli', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                            if (_isAsli == false) Text('Palsu', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isAsli ? 'Sistem memprediksi struk ini asli.' : 'Sistem memprediksi struk ini palsu.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Catatan: lakukan pengecekan manual pada bukti apabila diperlukan.',
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reject,
                    child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _accept,
                    child: const Text('Catat', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
