import 'package:flutter/material.dart';
import 'package:rukunin/pages/treasurer/transactions/transaction_detail.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const TransactionItem({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = (item['kind'] ?? '') == 'in';
    final bool isIuran = (item['category'] ?? '') == 'Iuran Bulanan';
    final amount = item['amount'] is num ? item['amount'] as num : 0;
    final amtStr = '${isIncome ? '+ ' : '- '}Rp ${_format(amount)}';
    final subtitle = isIuran
        ? 'Pembayaran dari ${item['name'] ?? '-'} (${item['rt'] ?? '-'})'
        : (item['note'] ?? '-');

    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => TransactionDetail(item: item))),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isIncome ? Colors.green : Colors.red).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['category'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amtStr,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _timeAgo(item['time'] as DateTime),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _format(num v) {
    final s = v.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} menit yang lalu';
    if (d.inHours < 24) return '${d.inHours} jam yang lalu';
    return '${d.inDays} hari yang lalu';
  }
}
