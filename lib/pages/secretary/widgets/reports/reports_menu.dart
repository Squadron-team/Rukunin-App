import 'package:flutter/material.dart';

// IMPORT halaman asli
import 'package:rukunin/pages/secretary/pages/incoming_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/outgoing_mail_screen.dart';
import 'package:rukunin/pages/secretary/pages/residents_data_screen.dart';

import 'package:rukunin/pages/secretary/widgets/reports/report_card.dart';

class ReportsMenu extends StatelessWidget {
  const ReportsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Cari laporan...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Menu laporan
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                ReportCard(
                  icon: Icons.inbox,
                  title: 'Surat Masuk',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IncomingMailScreen(),
                    ),
                  ),
                ),
                ReportCard(
                  icon: Icons.outbox,
                  title: 'Surat Keluar',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OutgoingMailScreen(),
                    ),
                  ),
                ),
                ReportCard(
                  icon: Icons.people,
                  title: 'Data Warga',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResidentsDataScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
