import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/iuran_info_card.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/bukti_pembayaran_card.dart';

class DataIuranDetail extends StatefulWidget {
  final Map<String, String> item;
  const DataIuranDetail({required this.item, super.key});

  @override
  State<DataIuranDetail> createState() => _DataIuranDetailState();
}

class _DataIuranDetailState extends State<DataIuranDetail> {
  late bool _isAsli;
  bool _isRevalidating = false;
  final TextEditingController _rejectNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final id = widget.item['id'];
    final p = id == null ? null : DataIuranRepository().prediction(id);
    _isAsli = p ?? true;
  }

  @override
  void dispose() {
    _rejectNoteCtrl.dispose();
    super.dispose();
  }

  Future<void> _revalidateReceipt() async {
    setState(() {
      _isRevalidating = true;
    });

    // TODO: Call ML API to revalidate the receipt
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRevalidating = false;
        // Simulate result change for demo
        // _isAsli = !_isAsli;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Validasi ulang selesai'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _accept() {
    final id = widget.item['id'];
    if (id != null) DataIuranRepository().verify(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pembayaran berhasil dikonfirmasi dan dicatat'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    context.pop(true);
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
          initialChildSize: 0.4,
          maxChildSize: 0.7,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tolak Pembayaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Berikan alasan penolakan kepada warga',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _rejectNoteCtrl,
                    minLines: 4,
                    maxLines: 6,
                    decoration:
                        buildInputDecoration(
                          'Alasan penolakan (opsional)',
                        ).copyWith(
                          hintText:
                              'Contoh: Bukti pembayaran tidak jelas atau nominal tidak sesuai',
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[800],
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Tolak',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
      if (id != null) {
        DataIuranRepository().reject(id, note.isEmpty ? null : note);
      }
      final msg = note.isEmpty
          ? 'Pembayaran ditolak'
          : 'Pembayaran ditolak. Notifikasi dikirim ke warga';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.pop(false);
    }
  }

  void _showFullImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 600),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const BuktiPembayaranCard(
                      proofUrl: null,
                      height: 600,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final hasNotes = item['notes']?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Detail Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Payment Info Card
            IuranInfoCard(
              name: item['name'] ?? '-',
              rt: item['rt'] ?? '-',
              type: item['type'] ?? '-',
              amount: item['amount'] ?? '-',
              time: item['time'] ?? '-',
            ),

            const SizedBox(height: 16),

            // Payment Method Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Transfer Bank',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (hasNotes) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Catatan dari Warga',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['notes'] ?? '',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Receipt Validation Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isAsli
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.error.withOpacity(0.2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Bukti Pembayaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _showFullImage,
                            icon: const Icon(Icons.zoom_in),
                            tooltip: 'Lihat Penuh',
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary.withOpacity(
                                0.12,
                              ),
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _showFullImage,
                        child: const BuktiPembayaranCard(
                          proofUrl: null,
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ML Detection Result
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isAsli
                              ? AppColors.success.withOpacity(0.08)
                              : AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isAsli
                                ? AppColors.success.withOpacity(0.3)
                                : AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _isAsli
                                        ? AppColors.success
                                        : AppColors.error,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _isAsli
                                        ? Icons.verified_outlined
                                        : Icons.warning_amber_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hasil Deteksi AI',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _isAsli
                                            ? 'Bukti Valid'
                                            : 'Perlu Pemeriksaan',
                                        style: TextStyle(
                                          color: _isAsli
                                              ? AppColors.success
                                              : AppColors.error,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _isRevalidating
                                      ? null
                                      : _revalidateReceipt,
                                  icon: _isRevalidating
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.refresh, size: 16),
                                  label: const Text('Cek Ulang'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isAsli
                                  ? 'Sistem AI menganalisis bukti ini sebagai gambar asli dan tidak terdeteksi adanya manipulasi digital.'
                                  : 'Sistem AI mendeteksi kemungkinan manipulasi pada bukti ini. Harap lakukan pemeriksaan manual dengan teliti.',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Bendahara tetap perlu melakukan verifikasi manual untuk memastikan kebenaran transaksi.',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _reject,
                    icon: const Icon(Icons.close, size: 20),
                    label: const Text(
                      'Tolak',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _accept,
                    icon: const Icon(Icons.check_circle, size: 20),
                    label: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
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
