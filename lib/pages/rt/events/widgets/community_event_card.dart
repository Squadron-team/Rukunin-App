import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/events/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/date_formatter.dart';

class CommunityEventCard extends StatelessWidget {
  final Event event;
  final int interestedCount;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CommunityEventCard({required this.event, this.interestedCount = 0, this.onTap, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime eventDate;
    try {
      eventDate = DateFormatter.fullDate.parse(event.date);
    } catch (_) {
      eventDate = DateTime.now();
    }

    final isPast = eventDate.isBefore(DateTime.now());

    // category chip colors
    final Color chipBg = isPast ? Colors.grey.withAlpha(20) : event.categoryColor.withAlpha(20);
    final Color? chipTextColor = isPast ? Colors.grey[700] : event.categoryColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Wider date column
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isPast ? Colors.grey.withAlpha(30) : event.categoryColor.withAlpha(20),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${eventDate.day}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: isPast ? Colors.grey[700] : event.categoryColor)),
                  const SizedBox(height: 6),
                  Text(
                    '${DateFormatter.monthName(eventDate)} ${eventDate.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(event.category, style: TextStyle(color: chipTextColor, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        const Spacer(),
                        Text(isPast ? 'Lewat' : 'Akan Datang', style: TextStyle(color: isPast ? Colors.grey : AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Row(children: [Icon(Icons.access_time, size: 14, color: Colors.grey[600]), const SizedBox(width: 6), Text(event.time, style: TextStyle(color: Colors.grey[700]))]),
                    const SizedBox(height: 6),
                    Row(children: [Icon(Icons.location_on, size: 14, color: Colors.grey[600]), const SizedBox(width: 6), Expanded(child: Text(event.location, style: TextStyle(color: Colors.grey[700]), overflow: TextOverflow.ellipsis))]),
                    const SizedBox(height: 10),
                    Row(children: [const Icon(Icons.favorite, size: 16, color: Colors.pinkAccent), const SizedBox(width: 6), Text('$interestedCount orang tertarik', style: const TextStyle(fontWeight: FontWeight.w700))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
