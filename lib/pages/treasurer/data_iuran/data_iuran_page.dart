import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/payment_verification_card.dart';

class DataIuranPage extends StatefulWidget {
  const DataIuranPage({super.key});

  @override
  State<DataIuranPage> createState() => _DataIuranPageState();
}

class _DataIuranPageState extends State<DataIuranPage> {
  final repo = DataIuranRepository();
  String _filterRt = 'Semua';

  List<String> get _rts {
    return ['Semua'] + List.generate(12, (i) => 'RT ${i + 1}');
  }

  List<Map<String, String>> get _visible {
    return repo.pendingByRt(_filterRt);
  }

  Future<void> _openPaymentDetail(Map<String, String> item) async {
    final result = await context.push('/treasurer/dues/detail', extra: item);
    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Verifikasi Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter RT chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _rts.map((rt) {
                  final selected = rt == _filterRt;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterRt = rt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          rt,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: selected ? Colors.white : Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // List or empty state
            Expanded(
              child: visible.isEmpty
                  ? Center(
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
                                Icons.check_circle_outline,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Semua Sudah Terverifikasi',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tidak ada pembayaran yang perlu diverifikasi saat ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final item = visible[i];
                        return PaymentVerificationCard(
                          payment: item,
                          onTap: () => _openPaymentDetail(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
