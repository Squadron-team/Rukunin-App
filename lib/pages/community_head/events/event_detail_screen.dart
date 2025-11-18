import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/community_head/events/widgets/community_small_detail_card.dart';
import 'package:rukunin/pages/community_head/events/event_edit_screen.dart';
import 'package:rukunin/utils/date_formatter.dart';

class CommunityHeadEventDetailScreen extends StatefulWidget {
  final Event event;
  final int interestedCount;

  const CommunityHeadEventDetailScreen({required this.event, this.interestedCount = 0, super.key});

  @override
  State<CommunityHeadEventDetailScreen> createState() => _CommunityHeadEventDetailScreenState();
}

class _CommunityHeadEventDetailScreenState extends State<CommunityHeadEventDetailScreen> {
  bool _showAllInterested = false;

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sosial':
        return Icons.people;
      case 'rapat':
        return Icons.meeting_room;
      case 'pendidikan':
        return Icons.school;
      case 'seni':
        return Icons.brush;
      case 'olahraga':
        return Icons.fitness_center;
      default:
        return Icons.label;
    }
  }
  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final interestedCount = widget.interestedCount;
    DateTime eventDate;
    try {
      eventDate = DateFormatter.fullDate.parse(event.date);
    } catch (_) {
      eventDate = DateTime.now();
    }
    final isPast = eventDate.isBefore(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(color: event.categoryColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          const Text('Detail Kegiatan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        leading: IconButton(
          icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 6, offset: Offset(0, 2))]), child: const Icon(Icons.arrow_back, color: Colors.black)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
            // Title card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 8, offset: Offset(0, 2))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: isPast ? Colors.grey.withAlpha(20) : event.categoryColor.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getCategoryIcon(event.category), size: 16, color: isPast ? Colors.grey[700] : event.categoryColor),
                        const SizedBox(width: 8),
                        Text(event.category, style: TextStyle(color: isPast ? Colors.grey[700] : event.categoryColor, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text('$interestedCount orang tertarik', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w700)),
                ])
              ]),
            ),

            const SizedBox(height: 16),

            CommunitySmallDetailCard(icon: Icons.calendar_today, title: 'Tanggal', subtitle: event.date, color: Colors.blue),
            CommunitySmallDetailCard(icon: Icons.access_time, title: 'Waktu', subtitle: event.time, color: Colors.green),
            CommunitySmallDetailCard(icon: Icons.location_on, title: 'Lokasi', subtitle: event.location, color: AppColors.primary, hasAction: false),

            const SizedBox(height: 12),

            // Description
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: Offset(0, 2))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(event.description, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6)),
              ]),
            ),

            const SizedBox(height: 16),

            // Interested list 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: Offset(0, 2))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Warga yang tertarik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                // show only up to 3 items
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _showAllInterested ? interestedCount : (interestedCount > 3 ? 3 : interestedCount),
                  itemBuilder: (c, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.12), child: Icon(Icons.person, color: AppColors.primary)),
                    title: Text('Warga ${i + 1}'),
                    subtitle: Text('RT 03 / Rumah ${i + 1}'),
                  ),
                ),
                if (interestedCount > 3)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() => _showAllInterested = !_showAllInterested),
                      child: Text(_showAllInterested ? 'Sembunyikan' : 'Lihat semua', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  ),
              ]),
            ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Floating edit button 
          Positioned(
            right: 8,
            bottom: 80,
            child: FloatingActionButton(
              heroTag: 'edit-event',
              backgroundColor: isPast ? Colors.grey[400] : AppColors.primary,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: isPast
                  ? null
                  : () async {
                      final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditEventScreen(event: event)));
                      if (res is Event) Navigator.pop(context, res);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
