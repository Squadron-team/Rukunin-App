import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class FinancialReportsPage extends StatefulWidget {
  const FinancialReportsPage({super.key});

  @override
  State<FinancialReportsPage> createState() => _FinancialReportsPageState();
}

class _FinancialReportsPageState extends State<FinancialReportsPage> {
  String _selectedPeriod = 'Bulan Ini';
  String _selectedType = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Laporan RT/RW'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterSection(),
              const SizedBox(height: 20),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              const Text(
                'Laporan Tersedia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildReportsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text(
          'Export',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            value: _selectedPeriod,
            items: [
              'Bulan Ini',
              'Bulan Lalu',
              '3 Bulan',
              '6 Bulan',
              'Tahun Ini',
            ],
            onChanged: (value) => setState(() => _selectedPeriod = value!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFilterDropdown(
            value: _selectedType,
            items: ['Semua', 'RT 01', 'RT 02', 'RT 03', 'RT 04'],
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Pemasukan',
                'Rp 45.5jt',
                Icons.trending_up,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Pengeluaran',
                'Rp 32.2jt',
                Icons.trending_down,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          'Saldo Akhir',
          'Rp 13.3jt',
          Icons.account_balance_wallet,
          AppColors.primary,
          isLarge: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: isLarge ? 28 : 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isLarge ? 14 : 12,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isLarge ? 22 : 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return Column(
      children: [
        _cardItem(
          context,
          title: 'Laporan Keuangan RT 01',
          period: 'Desember 2024',
          amount: 'Rp 12.500.000',
          isVerified: true,
        ),
        _cardItem(
          context,
          title: 'Laporan Keuangan RT 02',
          period: 'Desember 2024',
          amount: 'Rp 10.200.000',
          isVerified: true,
        ),
        _cardItem(
          context,
          title: 'Laporan Keuangan RT 03',
          period: 'Desember 2024',
          amount: 'Rp 8.900.000',
          isVerified: false,
        ),
        _cardItem(
          context,
          title: 'Laporan Keuangan RT 04',
          period: 'Desember 2024',
          amount: 'Rp 13.900.000',
          isVerified: true,
        ),
      ],
    );
  }

  Widget _cardItem(
    BuildContext context, {
    required String title,
    required String period,
    required String amount,
    required bool isVerified,
  }) {
    return InkWell(
      onTap: () {
        context.push('/admin/financial-reports/detail');
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assessment,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Terverifikasi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
