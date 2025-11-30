import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:go_router/go_router.dart';

class IuranListPage extends StatefulWidget {
  const IuranListPage({super.key});

  @override
  State<IuranListPage> createState() => _IuranListPageState();
}

class _IuranListPageState extends State<IuranListPage> {
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // 🔥 Sama seperti KeuanganDashboardPage
      appBar: AppBar(
        title: const Text(
          'Daftar Iuran',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + Filter
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

                  // Dropdown Filter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                        DropdownMenuItem(value: 'Lunas', child: Text('Lunas')),
                        DropdownMenuItem(
                          value: 'Belum Lunas',
                          child: Text('Belum Lunas'),
                        ),
                      ],
                      onChanged: (v) => setState(() => selectedFilter = v!),
                      underline: Container(),
                      isDense: true,
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ====== LIST IURAN (CARD BARU) ======
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
              _buildIuranCard(
                name: 'Rangga Saputra',
                period: 'Desember 2024',
                amount: 50000,
                status: 'Belum Lunas',
                paymentDate: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // 🔥 CARD IURAN STYLE PROFESIONAL (SAMA SEPERTI DASHBOARD)
  // ===========================================================
  Widget _buildIuranCard({
    required String name,
    required String period,
    required int amount,
    required String status,
    String? paymentDate,
  }) {
    bool isLunas = status == 'Lunas';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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

      // === isi card ===
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nama + Periode
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),

              // Badge Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLunas
                      ? Colors.green.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isLunas ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Nominal + Payment Button / Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nominal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nominal',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${_formatCurrency(amount)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // Jika sudah bayar → tampilkan tanggal
              if (paymentDate != null)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      paymentDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                // Jika belum → tombol bayar
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman catat pembayaran
                    context.push(
                      '/admin/iuran/payment',
                      extra: {'name': name, 'period': period, 'amount': amount},
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Bayar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Format angka ribuan
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
