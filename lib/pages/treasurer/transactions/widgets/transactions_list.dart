import 'package:flutter/material.dart';
import 'package:rukunin/repositories/transactions_repository.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final String? kind;
  final DateTime? start;
  final DateTime? end;

  const TransactionsList({super.key, this.kind, this.start, this.end});

  @override
  Widget build(BuildContext context) {
    final repo = transactionsRepository;
    List<Map<String, dynamic>> items = kind == null
        ? repo.all()
        : repo.filterByKind(kind!);

    if (start != null || end != null) {
      items = items.where((it) {
        final t = it['time'] as DateTime?;
        if (t == null) return false;
        if (start != null && t.isBefore(start!)) return false;
        if (end != null && t.isAfter(end!)) return false;
        return true;
      }).toList();
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.receipt_long,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada transaksi',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada transaksi sesuai periode atau filter yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: items.map((e) => TransactionItem(item: e)).toList(),
    );
  }
}
