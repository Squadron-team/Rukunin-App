import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/treasurer/data_iuran/data_iuran_page.dart';
import 'package:rukunin/pages/treasurer/data_iuran/data_iuran_detail.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';

class PaymentsAndTransactions extends StatelessWidget {
  const PaymentsAndTransactions({super.key});

  Widget _buildPaymentVerificationCard(
    BuildContext context, {
    required String name,
    required String rtInfo,
    required String amount,
    required String type,
    required String time,
    required Color color,
    Map<String, String>? item,
  }) {
    final isPalsu = (item?['prediction'] ?? '') == 'palsu';

    return Stack(
      children: [
        InkWell(
          onTap: () {
            // Open detail for this card when the whole card is tapped
            if (item != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DataIuranDetail(item: item)),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DataIuranDetail(
                    item: {
                      'name': 'Nama',
                      'rt': 'RT',
                      'type': 'Iuran Bulanan',
                      'amount': amount,
                      'time': time,
                    },
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
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
                      child: Icon(Icons.payment, color: color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$name ($rtInfo)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colors.grey[400],
                              ),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // If we have an item, verify directly and show snackbar like DataIuranPage.
                          if (item != null && item['id'] != null) {
                            final repo = DataIuranRepository();
                            repo.verify(item['id']!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Verifikasi berhasil'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }

                          // Fallback: open the full Data Iuran page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DataIuranPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Verifikasi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        onPressed: () {
                          // Open detail for this individual
                          if (item != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DataIuranDetail(item: item),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DataIuranDetail(
                                  item: {
                                    'name': 'Nama',
                                    'rt': 'RT',
                                    'type': 'Iuran Bulanan',
                                    'amount': amount,
                                    'time': time,
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        ),
                        tooltip: 'Detail',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isPalsu)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

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

    return items.map((it) {
      final amount = it['amount'] ?? '';
      final type = it['type'] ?? '';
      final color = type.contains('Tunggakan') ? Colors.orange : Colors.blue;
      return _buildPaymentVerificationCard(
        context,
        name: it['name'] ?? '',
        rtInfo: it['rt'] ?? '',
        amount: amount,
        type: it['type'] ?? '',
        time: it['time'] ?? '',
        color: color,
        item: it,
      );
    }).toList();
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required Color color,
    required bool isIncome,
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
        _buildTransactionCard(
          icon: Icons.arrow_downward,
          title: 'Iuran Bulanan',
          subtitle: 'Pembayaran dari Pak Budi (RT 03/15)',
          amount: '+ Rp 50.000',
          time: '5 menit yang lalu',
          color: Colors.green,
          isIncome: true,
        ),
        _buildTransactionCard(
          icon: Icons.arrow_upward,
          title: 'Pembelian Perlengkapan',
          subtitle: 'Alat kebersihan untuk kegiatan RW',
          amount: '- Rp 350.000',
          time: '30 menit yang lalu',
          color: Colors.red,
          isIncome: false,
        ),
        _buildTransactionCard(
          icon: Icons.arrow_downward,
          title: 'Iuran Bulanan',
          subtitle: 'Pembayaran dari Ibu Siti (RT 02/08)',
          amount: '+ Rp 50.000',
          time: '1 jam yang lalu',
          color: Colors.green,
          isIncome: true,
        ),
        _buildTransactionCard(
          icon: Icons.arrow_upward,
          title: 'Bayar Listrik Balai RW',
          subtitle: 'Pembayaran listrik bulan November',
          amount: '- Rp 450.000',
          time: '2 jam yang lalu',
          color: Colors.red,
          isIncome: false,
        ),
        _buildTransactionCard(
          icon: Icons.arrow_downward,
          title: 'Donasi Kegiatan',
          subtitle: 'Sumbangan untuk acara 17 Agustus',
          amount: '+ Rp 500.000',
          time: '3 jam yang lalu',
          color: Colors.green,
          isIncome: true,
        ),
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
