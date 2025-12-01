import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/payment_verification_card.dart';
import 'package:rukunin/repositories/transactions_repository.dart';

class PaymentsAndTransactions extends StatelessWidget {
  const PaymentsAndTransactions({super.key});

  List<Widget> _buildTopPayments(BuildContext context) {
    final repo = DataIuranRepository();
    final items = repo.all().take(2).toList();
    if (items.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
            ],
          ),
          child: const Text('Tidak ada pembayaran untuk diverifikasi'),
        ),
      ];
    }

    return items.map((it) => PaymentVerificationCard(item: it)).toList();
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required Color color,
  }) {
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTarget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Target Iuran Bulan Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terkumpul',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rp 10.950.000',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Target',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rp 12.250.000',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.894,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '89.4% Tercapai',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '219/245 KK',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    String category,
    String amount,
    Color color,
    double percentage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Pembayaran Menunggu Verifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Render top 2 recent payments from repository
        ..._buildTopPayments(context),
        const SizedBox(height: 32),
        const Text(
          'Transaksi Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Recent transactions from repository (sorted by time desc)
        ...() {
          final items = transactionsRepository.all();
          items.sort((a, b) {
            final at = a['time'] as DateTime?;
            final bt = b['time'] as DateTime?;
            if (at == null || bt == null) return 0;
            return bt.compareTo(at);
          });

          String relativeTime(DateTime t) {
            final diff = DateTime.now().difference(t);
            if (diff.inMinutes < 1) return 'Baru saja';
            if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
            if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
            return '${diff.inDays} hari yang lalu';
          }

          String amountString(Map<String, dynamic> it, bool isIn) {
            final amt = it['amount'] ?? 0;
            final prefix = isIn ? '+ Rp ' : '- Rp ';
            return '$prefix$amt';
          }

          return items.take(5).map((it) {
            final kind = (it['kind'] ?? '').toString();
            final isIncome = kind == 'in';
            final color = isIncome ? Colors.green : Colors.red;
            final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
            String subtitle;
            final note = (it['note'] ?? '').toString();
            final name = (it['name'] ?? '').toString();
            final rt = (it['rt'] ?? '').toString();
            if (note.isNotEmpty) {
              subtitle = note;
            } else if (name.isNotEmpty) {
              subtitle = 'Pembayaran dari $name (${rt.isNotEmpty ? rt : ''})'
                  .trim();
            } else {
              subtitle = (it['category'] ?? it['type'] ?? '').toString();
            }

            final title = (it['category'] ?? it['type'] ?? '').toString();
            final time = it['time'] is DateTime
                ? relativeTime(it['time'] as DateTime)
                : '';

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  context.push('/treasurer/transaction/detail', extra: it),
              child: _buildTransactionCard(
                icon: icon,
                title: title,
                subtitle: subtitle,
                amount: amountString(it, isIncome),
                time: time,
                color: color,
              ),
            );
          }).toList();
        }(),
        const SizedBox(height: 32),
        _buildMonthlyTarget(),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.1),
                Colors.purple.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pie_chart,
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Pengeluaran Per Kategori',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildExpenseItem(
                'Kegiatan & Acara',
                'Rp 2.500.000',
                Colors.purple,
                0.45,
              ),
              const SizedBox(height: 12),
              _buildExpenseItem(
                'Pemeliharaan Fasilitas',
                'Rp 1.800.000',
                Colors.blue,
                0.32,
              ),
              const SizedBox(height: 12),
              _buildExpenseItem(
                'Operasional',
                'Rp 950.000',
                Colors.orange,
                0.17,
              ),
              const SizedBox(height: 12),
              _buildExpenseItem('Lain-lain', 'Rp 350.000', Colors.grey, 0.06),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
