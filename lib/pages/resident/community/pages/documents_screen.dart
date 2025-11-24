import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/resident/community/services/document_service.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Pengajuan Surat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Jenis Surat'),
                  Tab(text: 'Riwayat'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _DocumentTypesTab(),
            _DocumentHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _DocumentTypesTab extends StatelessWidget {
  const _DocumentTypesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pilih jenis surat yang ingin Anda ajukan',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Document Type Cards
        _buildDocumentTypeCard(
          context,
          icon: Icons.home_outlined,
          title: 'Surat Keterangan Domisili',
          description: 'Surat keterangan tempat tinggal',
          color: Colors.blue,
          onTap: () => context.push('/resident/community/documents/domicile'),
        ),

        const SizedBox(height: 12),

        _buildDocumentTypeCard(
          context,
          icon: Icons.people_outline,
          title: 'Surat Keterangan Tidak Mampu',
          description: 'SKTM untuk keperluan administrasi',
          color: Colors.orange,
          onTap: () => context.push('/resident/community/documents/sktm'),
        ),

        const SizedBox(height: 12),

        _buildDocumentTypeCard(
          context,
          icon: Icons.business_outlined,
          title: 'Surat Keterangan Usaha',
          description: 'Keterangan untuk usaha rumahan',
          color: Colors.green,
          onTap: () => context.push('/resident/community/documents/business'),
        ),

        const SizedBox(height: 12),

        _buildDocumentTypeCard(
          context,
          icon: Icons.edit_document,
          title: 'Permohonan Koreksi Data',
          description: 'Koreksi data KTP/KK',
          color: Colors.purple,
          onTap: () => context.push('/resident/community/documents/correction'),
        ),

        const SizedBox(height: 12),

        _buildDocumentTypeCard(
          context,
          icon: Icons.family_restroom,
          title: 'Surat Keterangan Keluarga',
          description: 'Keterangan hubungan keluarga',
          color: Colors.teal,
          onTap: () => context.push('/resident/community/documents/family'),
        ),

        const SizedBox(height: 12),

        _buildDocumentTypeCard(
          context,
          icon: Icons.description_outlined,
          title: 'Surat Lainnya',
          description: 'Pengajuan surat umum lainnya',
          color: Colors.grey,
          onTap: () => context.push('/resident/community/documents/other'),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDocumentTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentHistoryTab extends StatefulWidget {
  const _DocumentHistoryTab();

  @override
  State<_DocumentHistoryTab> createState() => _DocumentHistoryTabState();
}

class _DocumentHistoryTabState extends State<_DocumentHistoryTab> {
  final _documentService = DocumentService();

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _documentService.getUserDocumentRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Terjadi kesalahan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Riwayat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Riwayat pengajuan surat akan muncul di sini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] as String? ?? 'pending';
            final statusColor = _getStatusColor(status);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
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
                      Expanded(
                        child: Text(
                          data['documentTitle'] as String? ?? 'Dokumen',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tujuan: ${data['purpose'] as String? ?? '-'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTimestamp(data['createdAt'] as Timestamp?),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (data['attachmentCount'] != null && data['attachmentCount'] > 0) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.attach_file,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${data['attachmentCount']} lampiran',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (data['adminNotes'] != null && (data['adminNotes'] as String).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Catatan: ${data['adminNotes']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
