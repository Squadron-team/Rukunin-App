import 'package:flutter/material.dart';
import 'package:rukunin/modules/notification/pages/notification_screen.dart';
import 'package:rukunin/pages/treasurer/widgets/welcome_card.dart';
import 'package:rukunin/pages/treasurer/widgets/cash_balance_overview.dart';
import 'package:rukunin/pages/treasurer/widgets/financial_summary.dart';
import 'package:rukunin/pages/treasurer/widgets/rt_payment_list.dart';
import 'package:rukunin/pages/treasurer/widgets/quick_actions_grid.dart';
import 'package:rukunin/pages/treasurer/widgets/payments_and_transactions.dart';

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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome + Balance
              WelcomeCard(),
              SizedBox(height: 24),
              CashBalanceOverview(),
              SizedBox(height: 24),

              FinancialSummary(),
              SizedBox(height: 24),

              Text(
                'Status Pembayaran RT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              RTPaymentList(),
              SizedBox(height: 32),

              Text(
                'Menu Bendahara',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              QuickActionsGrid(),
              SizedBox(height: 32),

              PaymentsAndTransactions(),
            ],
          ),
        ),
      ),
    );
  }
}
