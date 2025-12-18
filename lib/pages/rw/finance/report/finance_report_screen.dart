import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/finance/report/finance_report_card.dart';
import 'package:rukunin/pages/rw/finance/report/finance_report_chart.dart';
import 'package:rukunin/pages/rw/finance/report/finance_report_controller.dart';

class FinanceReportScreen extends StatefulWidget {
  const FinanceReportScreen({super.key});

  @override
  State<FinanceReportScreen> createState() => _FinanceReportScreenState();
}

class _FinanceReportScreenState extends State<FinanceReportScreen> {
  final controller = FinanceReportController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: FinanceReportCard(
                    title: 'Total Pemasukan',
                    amount: controller.totalIncome,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FinanceReportCard(
                    title: 'Total Pengeluaran',
                    amount: controller.totalExpenses,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chart
            const Text(
              'Grafik Keuangan Bulanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FinanceReportChart(data: controller.chartData),

            const SizedBox(height: 24),

            // Detail List
            const Text(
              'Rincian Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...controller.transactions.map((trx) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: trx['type'] == 'income'
                      ? Colors.green
                      : Colors.red,
                  child: Icon(
                    trx['type'] == 'income'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                title: Text(trx['title']),
                subtitle: Text(trx['date']),
                trailing: Text(
                  (trx['type'] == 'income' ? '+ ' : '- ') +
                      trx['amount'].toString(),
                  style: TextStyle(
                    color: trx['type'] == 'income' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
