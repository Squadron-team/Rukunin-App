import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/style/app_colors.dart';
import '../models/report_item.dart';

typedef StatusCallback = void Function(ReportItem item, String status);
typedef NoteCallback = void Function(ReportItem item);

class ReportCard extends StatelessWidget {
  final ReportItem item;
  final StatusCallback onStatusChange;
  final NoteCallback onAddNote;

  const ReportCard({required this.item, required this.onStatusChange, required this.onAddNote, super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return AppColors.primary;
      case 'resolved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime dt) => DateFormat('dd MMM yyyy • HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);
    final isFinal = item.status == 'resolved' || item.status == 'rejected';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(item.status.replaceAll('_', ' ').toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(item.description),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(item.location, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Text(_formatDate(item.createdAt), style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(item.reporter, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.note_add_outlined), tooltip: 'Tambah catatan', onPressed: () => onAddNote(item)),
          ]),
          if (item.note != null && item.note!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Text('Catatan: ${item.note}'),
              ),
            ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: (isFinal || item.status == 'in_progress')
                    ? null
                    : () {
                        onStatusChange(item, 'in_progress');
                      },
                child: const Text('Proses'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: (isFinal || item.status == 'resolved')
                    ? null
                    : () async {
                        final ok = await _showConfirmDialog(context, 'Selesaikan laporan?', 'Yakin ingin menandai laporan ini sebagai selesai?');
                        if (ok == true) onStatusChange(item, 'resolved');
                      },
                child: const Text('Selesai'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: (isFinal || item.status == 'rejected')
                    ? null
                    : () async {
                        final ok = await _showConfirmDialog(context, 'Tolak laporan?', 'Yakin ingin menolak laporan ini?');
                        if (ok == true) onStatusChange(item, 'rejected');
                      },
                child: const Text('Tolak'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: BorderSide(color: Colors.grey.shade300)),
            child: const Text('Batal'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  // Locked dialog removed: final statuses are disabled (buttons are greyed out).
}
