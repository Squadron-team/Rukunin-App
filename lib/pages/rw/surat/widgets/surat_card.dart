import 'package:flutter/material.dart';
import '../models/surat_model.dart';

class SuratCard extends StatelessWidget {
  final Surat surat;
  final VoidCallback onTap;

  const SuratCard({
    super.key,
    required this.surat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(surat.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconBySuratType(surat.jenis),
                      color: _getStatusColor(surat.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surat.jenis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          surat.nomor,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(surat.status),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    surat.pemohon,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    surat.tanggal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(StatusSurat status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status),
          width: 1,
        ),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

  IconData _getIconBySuratType(String jenis) {
    if (jenis.contains('Domisili')) return Icons.home;
    if (jenis.contains('KTP')) return Icons.badge;
    if (jenis.contains('Tidak Mampu')) return Icons.attach_money;
    if (jenis.contains('Usaha')) return Icons.business;
    if (jenis.contains('SKCK')) return Icons.verified_user;
    return Icons.description;
  }
}