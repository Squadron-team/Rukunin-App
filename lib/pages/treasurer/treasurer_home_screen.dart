import 'package:flutter/material.dart';
import 'package:rukunin/modules/notification/pages/notification_screen.dart';
import 'widgets/welcome_card.dart';
import 'widgets/cash_balance_overview.dart';
import 'widgets/financial_summary.dart';
import 'widgets/rt_payment_list.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/payments_and_transactions.dart';

class TreasurerHomeScreen extends StatelessWidget {
  const TreasurerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Selamat pagi, Bu Rina!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome + Balance
              const WelcomeCard(),
              const SizedBox(height: 24),
              const CashBalanceOverview(),
              const SizedBox(height: 24),

              const FinancialSummary(),
              const SizedBox(height: 24),

              const Text('Status Pembayaran RT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 16),
              const RTPaymentList(),
              const SizedBox(height: 32),

              const Text('Menu Bendahara', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 16),
              const QuickActionsGrid(),
              const SizedBox(height: 32),

              const PaymentsAndTransactions(),
            ],
          ),
        ),
      ),
    );
  }

}
