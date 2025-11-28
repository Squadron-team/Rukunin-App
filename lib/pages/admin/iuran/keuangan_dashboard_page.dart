import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';

class KeuanganDashboardPage extends StatelessWidget {
  const KeuanganDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Keuangan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Summary Cards
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildSummaryCard(
                      title: 'Total Pemasukan',
                      amount: 15000000,
                      icon: Icons.trending_up,
                      color: Colors.green,
                      isWide: isWide,
                    ),
                    _buildSummaryCard(
                      title: 'Total Pengeluaran',
                      amount: 8500000,
                      icon: Icons.trending_down,
                      color: Colors.red,
                      isWide: isWide,
                    ),
                    _buildSummaryCard(
                      title: 'Saldo Akhir',
                      amount: 6500000,
                      icon: Icons.account_balance_wallet,
                      color: AppColors.primary,
                      isWide: isWide,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // Statistik Iuran Bulan Ini
            const Text(
              'Iuran Bulan Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
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
                children: [
                  _buildStatRow(
                    label: 'Total Warga',
                    value: '50',
                    color: Colors.grey[700]!,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    label: 'Sudah Lunas',
                    value: '35 Warga',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    label: 'Belum Lunas',
                    value: '15 Warga',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Persentase Terkumpul',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '70%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      minHeight: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Quick Actions
            const Text(
              'Menu Cepat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.list_alt,
                      label: 'Lihat Semua Iuran',
                      color: AppColors.primary,
                      onTap: () => context.push('/admin/keuangan/iuran'),
                      isWide: isWide,
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.add_circle,
                      label: 'Catat Pembayaran',
                      color: Colors.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Fitur catat pembayaran akan segera tersedia',
                            ),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      isWide: isWide,
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.print,
                      label: 'Cetak Laporan',
                      color: Colors.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Fitur cetak laporan akan segera tersedia',
                            ),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      isWide: isWide,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int amount,
    required IconData icon,
    required Color color,
    required bool isWide,
  }) {
    double width = isWide ? 190 : double.infinity;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(
            'Rp ${_formatCurrency(amount)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isWide,
  }) {
    double width = isWide ? 190 : double.infinity;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
