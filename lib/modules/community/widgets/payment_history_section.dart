import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/payment_item_card.dart';

class PaymentHistorySection extends StatefulWidget {
  const PaymentHistorySection({super.key});

  @override
  State<PaymentHistorySection> createState() => _PaymentHistorySectionState();
}

class _PaymentHistorySectionState extends State<PaymentHistorySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Filter Tabs
          _buildFilterTabs(),

          const SizedBox(height: 16),

          // Payment History List
          _buildPaymentHistory(),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildFilterChip('All'),
        const SizedBox(width: 8),
        _buildFilterChip('Paid'),
        const SizedBox(width: 8),
        _buildFilterChip('Unpaid'),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistory() {
    List<Map<String, dynamic>> payments = [
      {'period': 'November 2025', 'amount': 'Rp 50.000', 'status': 'Unpaid'},
      {
        'period': 'Oktober 2025',
        'amount': 'Rp 50.000',
        'status': 'Paid',
        'date': '28 Okt 2025',
      },
      {
        'period': 'September 2025',
        'amount': 'Rp 50.000',
        'status': 'Paid',
        'date': '25 Sep 2025',
      },
      {
        'period': 'Agustus 2025',
        'amount': 'Rp 50.000',
        'status': 'Paid',
        'date': '30 Agu 2025',
      },
      {'period': 'Juli 2025', 'amount': 'Rp 50.000', 'status': 'Unpaid'},
    ];

    return Column(
      children: payments.map((payment) {
        return PaymentItemCard(
          period: payment['period'],
          amount: payment['amount'],
          status: payment['status'],
          date: payment['date'],
        );
      }).toList(),
    );
  }
}
