import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';

class IuranListPage extends StatefulWidget {
  const IuranListPage({super.key});

  @override
  State<IuranListPage> createState() => _IuranListPageState();
}

class _IuranListPageState extends State<IuranListPage> {
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Daftar Iuran',
      currentIndex: 2,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Iuran Warga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: const [
                      DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                      DropdownMenuItem(value: 'Lunas', child: Text('Lunas')),
                      DropdownMenuItem(value: 'Belum Lunas', child: Text('Belum Lunas')),
                    ],
                    onChanged: (v) => setState(() => selectedFilter = v!),
                    underline: Container(),
                    icon: Icon(Icons.filter_list, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card Iuran
              _buildIuranCard(
                name: 'Budi Santoso',
                period: 'Januari 2025',
                amount: 50000,
                status: 'Lunas',
                paymentDate: '05 Jan 2025',
              ),
              _buildIuranCard(
                name: 'Siti Aminah',
                period: 'Januari 2025',
                amount: 50000,
                status: 'Lunas',
                paymentDate: '03 Jan 2025',
              ),
              _buildIuranCard(
                name: 'Rangga Saputra',
                period: 'Januari 2025',
                amount: 50000,
                status: 'Belum Lunas',
                paymentDate: null,
              ),
              _buildIuranCard(
                name: 'Budi Santoso',
                period: 'Desember 2024',
                amount: 50000,
                status: 'Lunas',
                paymentDate: '28 Des 2024',
              ),
              _buildIuranCard(
                name: 'Siti Aminah',
                period: 'Desember 2024',
                amount: 50000,
                status: 'Lunas',
                paymentDate: '30 Des 2024',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIuranCard({
    required String name,
    required String period,
    required int amount,
    required String status,
    String? paymentDate,
  }) {
    bool isLunas = status == 'Lunas';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLunas
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isLunas ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nominal',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_formatCurrency(amount)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (paymentDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Dibayar',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          paymentDate,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ],
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