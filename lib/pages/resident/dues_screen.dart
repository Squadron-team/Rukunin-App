import 'package:flutter/material.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/widgets/cards/dues_summary_card.dart';
import 'package:rukunin/widgets/sections/announcements_dues_section.dart';
import 'package:rukunin/widgets/sections/communnity_summary_section.dart';
import 'package:rukunin/widgets/sections/payment_history_section.dart';

class DuesScreen extends StatelessWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int paidMonths = 8;
    const int totalMonths = 12;

    return const ResidentLayout(
      title: 'Iuran Warga',
      currentIndex: 2,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            // Dashboard / Summary Section
            DuesSummaryCard(paidMonths: paidMonths, totalMonths: totalMonths),
            SizedBox(height: 24),

            // Payment History Section
            PaymentHistorySection(),
            SizedBox(height: 24),

            // Community Summary Section
            CommunnitySummarySection(),
            SizedBox(height: 16),

            // Announcements Section
            AnnouncementsDuesSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
