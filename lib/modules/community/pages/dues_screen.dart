import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/modules/community/services/dues_service.dart';
import 'package:rukunin/modules/community/widgets/dues_summary_card.dart';
import 'package:rukunin/modules/community/widgets/communnity_summary_section.dart';
import 'package:rukunin/modules/community/widgets/payment_history_section.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class DuesScreen extends StatefulWidget {
  const DuesScreen({super.key});

  @override
  State<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends State<DuesScreen> {
  final DuesService _duesService = DuesService();
  final int _currentYear = DateTime.now().year;
  int _paidMonths = 0;
  final int _totalMonths = 12;

  @override
  void initState() {
    super.initState();
    _loadPaidMonths();
  }

  Future<void> _loadPaidMonths() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final paidMonths = await _duesService.getUserPaidMonths(
      userId,
      _currentYear,
    );
    if (mounted) {
      setState(() {
        _paidMonths = paidMonths.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Iuran Saya'),
      body: userId == null
          ? const Center(child: Text('Please login first'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  DuesSummaryCard(
                    paidMonths: _paidMonths,
                    totalMonths: _totalMonths,
                    onPaymentCompleted: _loadPaidMonths,
                  ),
                  const SizedBox(height: 24),
                  PaymentHistorySection(
                    userId: userId,
                    onPaymentSubmitted: _loadPaidMonths,
                  ),
                  const SizedBox(height: 24),
                  const CommunnitySummarySection(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
