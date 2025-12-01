import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class TransactionDetail extends StatelessWidget {
  final Map<String, dynamic> item;
  const TransactionDetail({required this.item, super.key});

  bool get _isIuranBulananVerified =>
      (item['kind'] == 'in' &&
      (item['category'] ?? '') == 'Iuran Bulanan' &&
      item['verified'] == true);

  String _formatCurrency(num v) {
    final s = v.toStringAsFixed(0);
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  String _formatDate(DateTime? t) {
    if (t == null) return '-';
    final dt = t.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  String _tepatWaktuLabel(DateTime? t) {
    if (t == null) return '-';
    return (t.day <= 10) ? 'Tepat Waktu' : 'Terlambat';
  }

  @override
  Widget build(BuildContext context) {
    final time = item['time'] as DateTime?;
    final amount = item['amount'] is num ? item['amount'] as num : 0;
    final rt = item['rt'] ?? '-';
    final name = item['name'] ?? '-';
    final category = item['category'] ?? '-';
    final note = item['note'] ?? '-';
    final type = item['type'] ?? category;
    final proof = item['proofUrl'] as String?;
    final transactionKind =
        (item['transaction'] ??
                (category == 'Iuran Bulanan' ? 'Transfer' : 'Transfer'))
            .toString();
    final statusFromRepo = (item['status'] != null)
        ? item['status'].toString()
        : null;
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Detail Transaksi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Icon(
                        item['kind'] == 'in'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '${item['kind'] == 'in' ? '+ ' : '- '}Rp ${_formatCurrency(amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: item['kind'] == 'in' ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Conditional fields
                if (_isIuranBulananVerified) ...[
                  _buildRow('Nama', name),
                  const SizedBox(height: 8),
                  _buildRow('Asal RT', rt),
                  const SizedBox(height: 8),
                  _buildRow('Jenis Iuran', type),
                  const SizedBox(height: 8),
                  _buildRow('Jenis Transaksi', 'Transfer'),
                  const SizedBox(height: 8),
                  _buildRow(
                    'Status',
                    statusFromRepo ?? _tepatWaktuLabel(time),
                    valueColor: (statusFromRepo != null)
                        ? (statusFromRepo.toLowerCase().contains('tepat')
                              ? Colors.green
                              : Colors.red)
                        : ((time != null && time.day <= 10)
                              ? Colors.green
                              : Colors.red),
                  ),
                  const SizedBox(height: 8),
                  _buildProof(
                    context,
                    proof,
                    height: 260,
                    placeholder: Icons.receipt_long,
                  ),
                ] else ...[
                  _buildRow('Keterangan', note),
                  const SizedBox(height: 8),
                  _buildRow('Jenis Transaksi', transactionKind),
                  const SizedBox(height: 8),
                  _buildRow('Tanggal', _formatDate(time)),
                  const SizedBox(height: 8),
                  _buildProof(
                    context,
                    proof,
                    height: 200,
                    placeholder: Icons.image_not_supported,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    final labelStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w500,
    );
    final valueStyle = valueColor != null
        ? TextStyle(color: valueColor, fontWeight: FontWeight.w600)
        : const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: labelStyle)),
        Expanded(child: Text(value, style: valueStyle)),
      ],
    );
  }

  Widget _buildProof(
    BuildContext context,
    String? proof, {
    double height = 200,
    IconData placeholder = Icons.image_not_supported,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            if (proof != null) {
              return Dialog(
                child: InteractiveViewer(
                  child: Image.network(proof, fit: BoxFit.contain),
                ),
              );
            }
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(
                      Icons.receipt_long,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: proof == null
            ? Center(child: Icon(placeholder, size: 48, color: Colors.grey))
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(proof, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
