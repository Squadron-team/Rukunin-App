import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/modules/community/pages/payment_confirmation_screen.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final String period;
  final String amount;

  const PaymentMethodBottomSheet({
    required this.period,
    required this.amount,
    super.key,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String period,
    required String amount,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PaymentMethodBottomSheet(period: period, amount: amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildPaymentMethod(context, Icons.account_balance, 'Transfer Bank'),
          _buildPaymentMethod(context, Icons.credit_card, 'Kartu Kredit/Debit'),
          _buildPaymentMethod(
            context,
            Icons.account_balance_wallet,
            'E-Wallet',
          ),
          _buildPaymentMethod(context, Icons.store, 'Minimarket'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentConfirmationScreen(
              period: period,
              amount: amount,
              paymentMethod: label,
            ),
          ),
        );

        // If payment was successful, pop the bottom sheet with success result
        if (result == true && context.mounted) {
          Navigator.pop(context, true);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
