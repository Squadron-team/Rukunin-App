import 'package:flutter/material.dart';
import 'package:rukunin/modules/community/widgets/dues_summary_card.dart';
import 'package:rukunin/modules/community/widgets/announcements_dues_section.dart';
import 'package:rukunin/modules/community/widgets/communnity_summary_section.dart';
import 'package:rukunin/modules/community/widgets/payment_history_section.dart';

class DuesScreen extends StatelessWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int paidMonths = 8;
    const int totalMonths = 12;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Iuran Saya',
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
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            DuesSummaryCard(paidMonths: paidMonths, totalMonths: totalMonths),
            SizedBox(height: 24),
            PaymentHistorySection(),
            SizedBox(height: 24),
            CommunnitySummarySection(),
            SizedBox(height: 16),
            AnnouncementsDuesSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
