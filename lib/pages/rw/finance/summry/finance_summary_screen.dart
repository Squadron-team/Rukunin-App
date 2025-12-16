import 'package:flutter/material.dart';

class FinanceSummaryScreen extends StatelessWidget {
  const FinanceSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          'Ringkasan RT',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================= SUMMARY HEADER (RINGKASAN RT) =======================
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Kas RT Saat Ini',
                    amount: 'Rp 8.190.000',
                    color: Colors.blueAccent,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    title: 'Iuran Bulan Ini',
                    amount: 'Rp 1.320.000',
                    color: Colors.green,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Pengeluaran Bulan Ini',
                    amount: 'Rp 650.000',
                    color: Colors.redAccent,
                    icon: Icons.trending_down_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    title: 'Jumlah Warga Bayar',
                    amount: '42 KK',
                    color: Colors.orange,
                    icon: Icons.people_alt_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ======================= GRAFIK IURAN =======================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grafik Iuran 6 Bulan Terakhir',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  // ======================= MINI BAR CHART =======================
                  SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Bar(month: 'Jun', height: 70),
                        _Bar(month: 'Jul', height: 90),
                        _Bar(month: 'Aug', height: 120),
                        _Bar(month: 'Sep', height: 85),
                        _Bar(month: 'Okt', height: 110),
                        _Bar(month: 'Nov', height: 130),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================= TRANSAKSI & KEGIATAN TERBARU =======================
            const Text(
              'Kegiatan & Transaksi RT Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _transactionItem(
              title: 'Iuran Bulanan – Warga Blok B',
              date: '10 Des 2025',
              amount: '+ Rp 120.000',
              color: Colors.green,
            ),

            _transactionItem(
              title: 'Pembelian Lampu Jalan RT',
              date: '8 Des 2025',
              amount: '- Rp 450.000',
              color: Colors.red,
            ),

            _transactionItem(
              title: 'Iuran Bulanan – Warga Blok A',
              date: '7 Des 2025',
              amount: '+ Rp 150.000',
              color: Colors.green,
            ),

            _transactionItem(
              title: 'Kegiatan Kerja Bakti Mingguan',
              date: '5 Des 2025',
              amount: '- Rp 200.000',
              color: Colors.red,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ======================= SUMMARY CARD =======================
  Widget _summaryCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ======================= TRANSACTION ITEM =======================
  Widget _transactionItem({
    required String title,
    required String date,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= MINI BAR CHART =======================
class _Bar extends StatelessWidget {
  final String month;
  final double height;

  const _Bar({required this.month, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: height,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
