import 'package:flutter/material.dart';

// ==== Import semua screen tujuan ====
import 'package:rukunin/pages/secretary/pages/incoming_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/outgoing_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/residents_data_screen.dart';
import 'package:rukunin/pages/secretary/pages/verification_screen.dart';
import 'package:rukunin/pages/secretary/pages/meeting_schedule_screen.dart';
import 'package:rukunin/pages/secretary/pages/minutes_screen.dart';

// ==== Import widgets ====
import 'package:rukunin/pages/secretary/widgets/archive/archive_search_bar.dart';
import 'package:rukunin/pages/secretary/widgets/archive/archive_recent_card.dart';
import 'package:rukunin/pages/secretary/widgets/archive/archive_category_card.dart';
import 'package:rukunin/pages/secretary/widgets/archive/archive_section_header.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  String searchQuery = '';

  // Dummy recent archive data
  final List<Map<String, String>> recentArchive = [
    {'title': 'Surat Masuk - RT 01', 'date': '28 Nov 2025'},
    {'title': 'Notulen Rapat Mingguan', 'date': '25 Nov 2025'},
    {'title': 'Surat Keluar Dinas', 'date': '20 Nov 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(title: const Text('Arsip'), elevation: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔎 SEARCH BAR
            ArchiveSearchBar(
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),

            // 🗂️ CATEGORY SECTION
            const ArchiveSectionHeader(title: 'Kategori Arsip'),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.85,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                ArchiveCategoryCard(
                  icon: Icons.inbox,
                  color: Colors.blue,
                  label: 'Surat Masuk',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const IncomingMailScreen(),
                      ),
                    );
                  },
                ),
                ArchiveCategoryCard(
                  icon: Icons.outbox,
                  color: Colors.orange,
                  label: 'Surat Keluar',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OutgoingMailScreen(),
                      ),
                    );
                  },
                ),
                ArchiveCategoryCard(
                  icon: Icons.people,
                  color: Colors.green,
                  label: 'Data Warga',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResidentsDataScreen(),
                      ),
                    );
                  },
                ),
                ArchiveCategoryCard(
                  icon: Icons.fact_check,
                  color: Colors.purple,
                  label: 'Verifikasi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerificationScreen(),
                      ),
                    );
                  },
                ),
                ArchiveCategoryCard(
                  icon: Icons.meeting_room,
                  color: Colors.red,
                  label: 'Jadwal Rapat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MeetingScheduleScreen(),
                      ),
                    );
                  },
                ),
                ArchiveCategoryCard(
                  icon: Icons.event_note,
                  color: Colors.cyan,
                  label: 'Notulen',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MinutesScreen()),
                    );
                  },
                ),
              ],
            ),

            // 📁 RECENT SECTION
            const ArchiveSectionHeader(title: 'Arsip Terbaru'),

            Column(
              children: List.generate(recentArchive.length, (index) {
                final item = recentArchive[index];

                // FILTER SEARCH
                if (searchQuery.isNotEmpty &&
                    !item['title']!.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    )) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ArchiveRecentCard(
                    title: item['title']!,
                    date: item['date']!,
                    onTap: () {},
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
