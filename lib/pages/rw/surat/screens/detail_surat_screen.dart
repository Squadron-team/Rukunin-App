import 'package:flutter/material.dart';
import '../models/surat_model.dart';

class DetailSuratScreen extends StatelessWidget {
  final Surat surat;

  const DetailSuratScreen({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Surat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implementasi edit
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Implementasi print
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 16),
            _buildDetailSection(context),
            const SizedBox(height: 24),
            if (surat.status == StatusSurat.menunggu) _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _getStatusIcon(surat.status),
              size: 60,
              color: _getStatusColor(surat.status),
            ),
            const SizedBox(height: 16),
            Text(
              surat.jenis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              surat.nomor,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(surat.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                surat.status.displayName,
                style: TextStyle(
                  color: _getStatusColor(surat.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Detail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildDetailRow(Icons.person, 'Pemohon', surat.pemohon),
            _buildDetailRow(Icons.calendar_today, 'Tanggal', surat.tanggal),
            _buildDetailRow(Icons.home, 'Alamat', surat.alamat ?? 'Jl. Contoh No. 123, RT 02/RW 05'),
            _buildDetailRow(Icons.description, 'Keperluan', surat.keperluan ?? 'Administrasi kependudukan'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showConfirmDialog(context, 'Setujui', Colors.green);
            },
            icon: const Icon(Icons.check),
            label: const Text('Setujui'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showConfirmDialog(context, 'Tolak', Colors.red);
            },
            icon: const Icon(Icons.close),
            label: const Text('Tolak'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context, String action, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Surat?'),
        content: Text('Apakah Anda yakin ingin ${action.toLowerCase()} surat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Surat berhasil di${action.toLowerCase()}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(StatusSurat status) {
    switch (status) {
      case StatusSurat.menunggu:
        return Icons.pending;
      case StatusSurat.disetujui:
        return Icons.check_circle;
      case StatusSurat.ditolak:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(StatusSurat status) {
    switch (status) {
      case StatusSurat.menunggu:
        return Colors.orange;
      case StatusSurat.disetujui:
        return Colors.green;
      case StatusSurat.ditolak:
        return Colors.red;
    }
  }
}