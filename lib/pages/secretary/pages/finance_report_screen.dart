import 'package:flutter/material.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari transaksi...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List transaksi keuangan
            Expanded(
              child: ListView(
                children: [
                  financeItem(
                    title: 'Pemasukan Iuran Warga',
                    amount: '+ Rp 2.500.000',
                    color: Colors.green,
                    date: '10 Januari 2025',
                  ),
                  financeItem(
                    title: 'Pembelian ATK Kantor',
                    amount: '- Rp 350.000',
                    color: Colors.red,
                    date: '09 Januari 2025',
                  ),
                  financeItem(
                    title: 'Dana Kegiatan RT',
                    amount: '- Rp 1.200.000',
                    color: Colors.red,
                    date: '05 Januari 2025',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget financeItem({
    required String title,
    required String amount,
    required Color color,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title & date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          // Amount
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
