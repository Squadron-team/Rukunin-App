import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/pages/rt/meetings/models/meeting.dart';
import 'package:rukunin/repositories/meeting_repository.dart';
import 'package:rukunin/theme/app_colors.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback? onTap;

  const MeetingCard({required this.meeting, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(meeting.dateTime);

    String relativeLabel() {
      final now = DateTime.now();
      final a = DateTime(now.year, now.month, now.day);
      final b = DateTime(
        meeting.dateTime.year,
        meeting.dateTime.month,
        meeting.dateTime.day,
      );
      final diff = b.difference(a).inDays; // positive = future
      if (diff == 0) return 'Hari ini';
      if (diff == 1) return 'Besok';
      if (diff == -1) return '1 hari lalu';
      if (diff > 1 && diff < 7) return '$diff hari lagi';
      if (diff < -1 && diff > -7) return '${-diff} hari lalu';
      if (diff >= 7 && diff < 14) return '1 minggu lagi';
      if (diff <= -7 && diff > -14) return '1 minggu lalu';
      return DateFormat('yyyy-MM-dd').format(meeting.dateTime);
    }

    final now = DateTime.now();
    final isPast = meeting.dateTime.isBefore(now);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.meeting_room, color: Colors.blue),
        ),
        title: Text(
          meeting.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('${relativeLabel()} • $timeStr'),
            const SizedBox(height: 4),
            Text(
              meeting.location,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          if (onTap != null) onTap!();
        },
        trailing: Builder(
          builder: (context) {
            // Disabled past button
            if (isPast) {
              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[700],
                  minimumSize: const Size(84, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Selesai'),
              );
            }

            if (meeting.isAttending) {
              return OutlinedButton(
                onPressed: () {
                  MeetingRepository.toggleAttend(meeting.id);
                  // snackbar
                  final msg = meeting.isAttending
                      ? 'Kehadiran tercatat'
                      : 'Kehadiran dibatalkan';
                  final color = meeting.isAttending
                      ? Colors.green
                      : Colors.orange;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      backgroundColor: color,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  (context as Element).markNeedsBuild();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange.shade700),
                  foregroundColor: Colors.orange.shade700,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(84, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Batal'),
              );
            }

            return ElevatedButton(
              onPressed: () {
                MeetingRepository.toggleAttend(meeting.id);
                // snackbar
                final msg = meeting.isAttending
                    ? 'Kehadiran tercatat'
                    : 'Kehadiran dibatalkan';
                final color = meeting.isAttending
                    ? Colors.green
                    : Colors.orange;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                (context as Element).markNeedsBuild();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(84, 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text('Hadir'),
            );
          },
        ),
      ),
    );
  }
}
