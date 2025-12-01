import 'package:flutter/material.dart';
import 'package:rukunin/pages/treasurer/widgets/welcome_card.dart';
import 'package:rukunin/pages/treasurer/widgets/cash_balance_overview.dart';
import 'package:rukunin/pages/treasurer/widgets/financial_summary.dart';
import 'package:rukunin/pages/treasurer/widgets/rt_payment_list.dart';
import 'package:rukunin/pages/treasurer/widgets/quick_actions_grid.dart';
import 'package:rukunin/pages/treasurer/widgets/payments_and_transactions.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class TreasurerHomeScreen extends StatelessWidget {
  const TreasurerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
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
