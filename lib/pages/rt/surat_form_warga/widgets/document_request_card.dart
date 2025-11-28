import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/surat_form_warga/models/document_request.dart';
import 'package:rukunin/style/app_colors.dart';

class DocumentRequestCard extends StatelessWidget {
  final DocumentRequest request;
  final VoidCallback? onView;
  final void Function(String status)? onChangeStatus;

  const DocumentRequestCard({
    required this.request,
    super.key,
    this.onView,
    this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    String relativeTime(DateTime dt) {
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} menit yang lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
      return '${diff.inDays} hari yang lalu';
    }


    final dateLabel = relativeTime(request.createdAt.toLocal());

    Color statusColor(String s) {
      if (s == 'ditolak') return Colors.red;
      if (s == 'diterima') return Colors.green;
      return Colors.orange; 
    }

    final sColor = statusColor(request.status);

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: onView,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 56.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          request.requester,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request.status.isNotEmpty
                      ? '${request.status[0].toUpperCase()}${request.status.substring(1)}'
                      : request.status,
                  style: TextStyle(
                    color: sColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
