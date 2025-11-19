import 'package:flutter/material.dart';
import 'package:rukunin/pages/resident/dues/widgets/dues_summary_card.dart';
import 'package:rukunin/pages/resident/dues/widgets/announcements_dues_section.dart';
import 'package:rukunin/pages/resident/dues/widgets/communnity_summary_section.dart';
import 'package:rukunin/pages/resident/dues/widgets/payment_history_section.dart';
import 'package:rukunin/pages/resident/dues/widgets/finance_transparency_section.dart';
import 'package:rukunin/style/app_colors.dart';

class DuesScreen extends StatelessWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int paidMonths = 8;
    const int totalMonths = 12;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Iuran Warga',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.account_balance_wallet, size: 20),
                    text: 'Iuran Saya',
                  ),
                  Tab(
                    icon: Icon(Icons.trending_up, size: 20),
                    text: 'Transparansi Keuangan',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            // Dues Tab
            SingleChildScrollView(
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
            // Finance Transparency Tab
            FinanceTransparencySection(),
          ],
        ),
      ),
    );
  }
}
