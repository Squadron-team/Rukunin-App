import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Halaman detail pengajuan surat yang menunggu persetujuan sekretaris
class LetterApprovalDetailScreen extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic>? requestData;

  const LetterApprovalDetailScreen({
    required this.requestId,
    super.key,
    this.requestData,
  });

  @override
  Widget build(BuildContext context) {
    // Contoh data fallback kalau extra null (bisa diganti dengan fetch API nanti)
    final data = requestData ?? {};

    final String documentType =
        data['documentType']?.toString().capitalize() ??
        data['type']?.toString().capitalize() ??
        'Tidak diketahui';

    final String applicantName =
        data['applicantName']?.toString() ??
        data['name']?.toString() ??
        'Warga';

    final String status = data['status']?.toString().toUpperCase() ?? 'PENDING';
    final DateTime? createdAt = data['createdAt'] != null
        ? DateTime.tryParse(data['createdAt'].toString())
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan Surat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Pengajuan',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      requestId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoChip('Jenis Surat', documentType),
                        _buildStatusChip(status),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Informasi Pemohon
            _buildSectionTitle(context, 'Informasi Pemohon'),
            _buildInfoRow('Nama', applicantName),
            _buildInfoRow('NIK', data['nik']?.toString() ?? '-'),
            _buildInfoRow('No. KK', data['noKk']?.toString() ?? '-'),
            _buildInfoRow('Alamat', data['address']?.toString() ?? '-'),
            _buildInfoRow('No. Telepon', data['phone']?.toString() ?? '-'),

            const SizedBox(height: 20),

            // Tanggal Pengajuan
            if (createdAt != null)
              _buildInfoRow(
                'Tanggal Pengajuan',
                '${createdAt.day}/${createdAt.month}/${createdAt.year}',
              ),

            const SizedBox(height: 30),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      // TODO: Implementasi tolak pengajuan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur tolak belum diimplementasikan'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Setujui'),
                    onPressed: () {
                      // TODO: Implementasi setujui pengajuan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur setujui belum diimplementasikan',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blue.shade50,
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'APPROVED':
        color = Colors.green;
        break;
      case 'REJECTED':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }
    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}

// Extension untuk capitalize string (opsional, biar rapi)
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
