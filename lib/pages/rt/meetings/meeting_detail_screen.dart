import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/meeting.dart';
import '../../../repositories/meeting_repository.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:rukunin/modules/activities/widgets/small_activity_detail_card.dart';
import 'package:rukunin/modules/activities/widgets/activity_organizer_card.dart';

class MeetingDetailScreen extends StatefulWidget {
  final Meeting meeting;

  const MeetingDetailScreen({required this.meeting, super.key});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  late Meeting m;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    m = widget.meeting;
  }

  void _toggleAttend() async {
    if (m.dateTime.isBefore(DateTime.now())) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 250));
    MeetingRepository.toggleAttend(m.id);
    final updated = MeetingRepository.all().firstWhere((it) => it.id == m.id, orElse: () => m);
    setState(() {
      m = updated;
      _isLoading = false;
    });
    // snackbar 
    final msg = m.isAttending ? 'Kehadiran tercatat' : 'Kehadiran dibatalkan';
    final color = m.isAttending ? Colors.green : Colors.orange;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, d MMMM yyyy', 'id').format(m.dateTime);
    final timeStr = DateFormat('HH:mm').format(m.dateTime);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detail Rapat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20)),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.08), width: 1)),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, -1))],
              ),
              child: Text(m.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3)),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SmallActivityDetailCard(
                icon: Icons.calendar_today,
                title: 'Tanggal',
                subtitle: dateStr,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SmallActivityDetailCard(
                icon: Icons.access_time,
                title: 'Waktu',
                subtitle: timeStr,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SmallActivityDetailCard(
                icon: Icons.location_on,
                title: 'Lokasi',
                subtitle: m.location,
                color: AppColors.primary,
                hasAction: true,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      Text(
                        m.description,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        Text('${m.attendeesCount} orang hadir', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 12),
                      if (m.attendingRTs.isNotEmpty) ...[
                        const Text('Ketua RT yang hadir', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: m.attendingRTs.map((r) => Chip(label: Text(r))).toList(),
                        ),
                      ],
                    ]),
                  ),

                  const SizedBox(height: 12),
                  ActivityOrganizerCard(
                    name: m.attendingRTs.isNotEmpty ? m.attendingRTs.first : 'Panitia RT',
                    position: 'Penyelenggara',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, -4))]),
        child: SafeArea(
          child: Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: m.dateTime.isBefore(DateTime.now()) ? null : _toggleAttend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: m.dateTime.isBefore(DateTime.now())
                      ? Colors.grey[300]
                      : (m.isAttending ? Colors.orange : AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: LoadingIndicator())
                    : Text(
                        m.isAttending ? 'Batal Hadir' : 'Hadir',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
