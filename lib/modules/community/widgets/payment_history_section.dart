import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/modules/community/widgets/components/payment_item_card.dart';
import 'package:rukunin/modules/community/services/dues_service.dart';
import 'package:rukunin/modules/community/models/dues_payment.dart';

class PaymentHistorySection extends StatefulWidget {
  const PaymentHistorySection({
    required this.userId,
    this.onPaymentSubmitted,
    super.key,
  });

  final String userId;
  final VoidCallback? onPaymentSubmitted;

  @override
  State<PaymentHistorySection> createState() => _PaymentHistorySectionState();
}

class _PaymentHistorySectionState extends State<PaymentHistorySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final DuesService _duesService = DuesService();
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
    return StreamBuilder<List<DuesPayment>>(
      stream: _duesService.getUserPayments(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final allPayments = snapshot.data ?? [];

        // Filter payments based on selected filter
        final filteredPayments = _selectedFilter == 'All'
            ? allPayments
            : _selectedFilter == 'Paid'
            ? allPayments
                  .where(
                    (p) =>
                        p.status == PaymentStatus.verified ||
                        p.status == PaymentStatus.autoVerified,
                  )
                  .toList()
            : allPayments
                  .where(
                    (p) =>
                        p.status == PaymentStatus.pending ||
                        p.status == PaymentStatus.rejected,
                  )
                  .toList();

        if (filteredPayments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Belum ada riwayat pembayaran',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          );
        }

        return Column(
          children: filteredPayments.map((payment) {
            return PaymentItemCard(
              period: '${payment.month} ${payment.year}',
              amount: 'Rp ${payment.amount.toStringAsFixed(0)}',
              status: _getStatusString(payment.status),
              date:
                  '${payment.createdAt.day}/${payment.createdAt.month}/${payment.createdAt.year}',
            );
          }).toList(),
        );
      },
    );
  }

  String _getStatusString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.verified:
      case PaymentStatus.autoVerified:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.rejected:
        return 'Rejected';
    }
  }
}
