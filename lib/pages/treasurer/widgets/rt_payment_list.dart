import 'package:flutter/material.dart';

class RTPaymentList extends StatelessWidget {
  const RTPaymentList({super.key});

  Widget _buildRTPaymentCard({
    required String rtNumber,
    required int totalKK,
    required int paidKK,
    required String amount,
    required Color color,
  }) {
    final percentage = (paidKK / totalKK * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    rtNumber,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RT $rtNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$paidKK/$totalKK KK Bayar ($percentage%)',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      percentage >= 95
                          ? 'Sangat Baik'
                          : percentage >= 85
                          ? 'Baik'
                          : 'Perlu Perhatian',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRTPaymentCard(
          rtNumber: '01',
          totalKK: 48,
          paidKK: 42,
          amount: 'Rp 2.100.000',
          color: Colors.green,
        ),
        _buildRTPaymentCard(
          rtNumber: '02',
          totalKK: 52,
          paidKK: 45,
          amount: 'Rp 2.250.000',
          color: Colors.green,
        ),
        _buildRTPaymentCard(
          rtNumber: '03',
          totalKK: 45,
          paidKK: 38,
          amount: 'Rp 1.900.000',
          color: Colors.orange,
        ),
        _buildRTPaymentCard(
          rtNumber: '04',
          totalKK: 50,
          paidKK: 50,
          amount: 'Rp 2.500.000',
          color: Colors.blue,
        ),
        _buildRTPaymentCard(
          rtNumber: '05',
          totalKK: 50,
          paidKK: 44,
          amount: 'Rp 2.200.000',
          color: Colors.green,
        ),
      ],
    );
  }
}
