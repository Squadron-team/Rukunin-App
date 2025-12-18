import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/modules/community/models/dues_payment.dart';
import 'package:rukunin/modules/community/services/dues_service.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/iuran_info_card.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/bukti_pembayaran_card.dart';
import 'package:rukunin/pages/general/ml_inference_test/services/ml_firebase_service.dart';
import 'package:http/http.dart' as http;

class DataIuranDetail extends StatefulWidget {
  final DuesPayment payment;
  const DataIuranDetail({required this.payment, super.key});

  @override
  State<DataIuranDetail> createState() => _DataIuranDetailState();
}

class _DataIuranDetailState extends State<DataIuranDetail> {
  final DuesService _duesService = DuesService();
  bool _isRevalidating = false;
  bool _isProcessing = false;
  final TextEditingController _rejectNoteCtrl = TextEditingController();
  Map<String, dynamic>? _validationResult;

  @override
  void dispose() {
    _rejectNoteCtrl.dispose();
    super.dispose();
  }

  Future<void> _revalidateReceipt() async {
    setState(() {
      _isRevalidating = true;
    });

    try {
      // Download the receipt image
      final response = await http.get(
        Uri.parse(widget.payment.receiptImageUrl),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to download receipt image');
      }

      final imageBytes = response.bodyBytes;
      final expectedAmount = 'Rp${widget.payment.amount.toStringAsFixed(0)}';

      // Call Firebase Functions to validate receipt
      final result = await MLFirebaseService.detectFakeReceipt(
        imageBytes,
        expectedAmount,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        setState(() {
          _validationResult = result;
        });

        final verification = result['verification'] as Map<String, dynamic>?;
        final summary = verification?['summary'] as Map<String, dynamic>?;
        final isPassed = summary?['passed'] == true;
        final verdict = summary?['final_verdict'] ?? 'Unknown';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Validasi ulang selesai: $verdict'),
            backgroundColor: isPassed ? AppColors.success : AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error validasi: ${result['error'] ?? 'Unknown error'}',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRevalidating = false;
        });
      }
    }
  }

  Future<void> _accept() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final success = await _duesService.verifyPayment(
      widget.payment.id!,
      currentUser.uid,
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pembayaran berhasil dikonfirmasi dan dicatat'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengkonfirmasi pembayaran'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reject() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
              child: SingleChildScrollView(
                controller: controller,
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
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
              ),
            );
          },
        );
      },
    );

    if (ok == true) {
      setState(() {
        _isProcessing = true;
      });

      final note = _rejectNoteCtrl.text.trim();
      final success = await _duesService.rejectPayment(
        widget.payment.id!,
        currentUser.uid,
        note.isEmpty ? 'Bukti pembayaran tidak valid' : note,
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (success) {
          final msg = note.isEmpty
              ? 'Pembayaran ditolak'
              : 'Pembayaran ditolak. Notifikasi dikirim ke warga';
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
          context.pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menolak pembayaran'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 32,
                      maxHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.payment.receiptImageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red[400],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Gagal memuat gambar',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
    final payment = widget.payment;
    final isAsli =
        payment.verificationScore != null && payment.verificationScore! >= 0.7;

    // Check if we have a validation result from revalidation
    bool isRevalidated = _validationResult != null;
    bool isRevalidatedValid = false;
    double? revalidationScore;

    if (isRevalidated) {
      final verification =
          _validationResult!['verification'] as Map<String, dynamic>?;
      final summary = verification?['summary'] as Map<String, dynamic>?;
      final layoutValidation =
          verification?['layout_validation'] as Map<String, dynamic>?;

      isRevalidatedValid = summary?['passed'] == true;
      revalidationScore = layoutValidation?['similarity_score'];
    }

    // Use revalidation result if available, otherwise use original
    final displayIsValid = isRevalidated ? isRevalidatedValid : isAsli;
    final displayScore = isRevalidated
        ? revalidationScore
        : payment.verificationScore;

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
              name: payment.userName,
              rt: 'RT ${payment.rt}',
              type: '${payment.month} ${payment.year}',
              amount: 'Rp ${payment.amount.toStringAsFixed(0)}',
              time:
                  '${payment.createdAt.day}/${payment.createdAt.month}/${payment.createdAt.year} ${payment.createdAt.hour}:${payment.createdAt.minute.toString().padLeft(2, '0')}',
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
                    color: displayIsValid
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
                        child: BuktiPembayaranCard(
                          proofUrl: payment.receiptImageUrl,
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ML Detection Result
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: displayIsValid
                              ? AppColors.success.withOpacity(0.08)
                              : AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: displayIsValid
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
                                    color: displayIsValid
                                        ? AppColors.success
                                        : AppColors.error,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    displayIsValid
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
                                      Row(
                                        children: [
                                          const Text(
                                            'Hasil Deteksi AI',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (isRevalidated) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'UPDATED',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        displayIsValid
                                            ? 'Bukti Valid'
                                            : 'Perlu Pemeriksaan',
                                        style: TextStyle(
                                          color: displayIsValid
                                              ? AppColors.success
                                              : AppColors.error,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (displayScore != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Skor: ${(displayScore * 100).toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
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
                              displayIsValid
                                  ? 'Sistem AI menganalisis bukti ini sebagai gambar asli dan tidak terdeteksi adanya manipulasi digital.'
                                  : 'Sistem AI mendeteksi kemungkinan manipulasi pada bukti ini. Harap lakukan pemeriksaan manual dengan teliti.',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            if (isRevalidated &&
                                _validationResult!['verification'] != null) ...[
                              const Divider(height: 20),
                              _buildValidationDetails(
                                _validationResult!['verification'],
                              ),
                            ],
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
                    onPressed: _isProcessing ? null : _reject,
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.close, size: 20),
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
                    onPressed: _isProcessing ? null : _accept,
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle, size: 20),
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

  Widget _buildValidationDetails(Map<String, dynamic> verification) {
    final fieldVerification =
        verification['field_verification'] as Map<String, dynamic>?;
    final lineValidation =
        verification['line_validation'] as Map<String, dynamic>?;
    final layoutValidation =
        verification['layout_validation'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Validasi:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (fieldVerification != null) ...[
          ...fieldVerification.entries.take(2).map((entry) {
            final field = entry.value as Map<String, dynamic>;
            final isMatch = field['is_match'] == true;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    isMatch ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: isMatch ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${entry.key.replaceAll('_', ' ')}: ${field['expected']} ${isMatch ? '✓' : '✗'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        if (lineValidation != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                lineValidation['is_valid'] == true
                    ? Icons.check_circle
                    : Icons.info,
                size: 14,
                color: lineValidation['is_valid'] == true
                    ? AppColors.success
                    : Colors.orange,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Lines: ${lineValidation['detected_lines']}/${lineValidation['expected_lines']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
        if (layoutValidation != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                layoutValidation['is_valid'] == true
                    ? Icons.check_circle
                    : Icons.info,
                size: 14,
                color: layoutValidation['is_valid'] == true
                    ? AppColors.success
                    : Colors.orange,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Layout similarity: ${((layoutValidation['similarity_score'] ?? 0) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
