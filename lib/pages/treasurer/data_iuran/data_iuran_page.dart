import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/modules/community/services/dues_service.dart';
import 'package:rukunin/modules/community/models/dues_payment.dart';
import 'package:rukunin/pages/treasurer/data_iuran/widgets/payment_verification_card.dart';

class DataIuranPage extends StatefulWidget {
  const DataIuranPage({super.key});

  @override
  State<DataIuranPage> createState() => _DataIuranPageState();
}

class _DataIuranPageState extends State<DataIuranPage> {
  final DuesService _duesService = DuesService();
  String _filterRt = 'Semua';
  bool _isInitialLoad = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Wait a bit to show initial loading
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isInitialLoad = false;
      });
    }
  }

  List<String> get _rts {
    return ['Semua'] + List.generate(12, (i) => 'RT ${i + 1}');
  }

  Future<void> _openPaymentDetail(DuesPayment payment) async {
    final result = await context.push('/treasurer/dues/detail', extra: payment);
    if (result == true && mounted) {
      setState(() {});
    }
  }

  Widget _buildEmptyState() {
    return Center(
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
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada pembayaran yang perlu diverifikasi saat ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text(
            'Terjadi Kesalahan',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isInitialLoad = true;
                _errorMessage = null;
              });
              _initializeData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Memuat data pembayaran...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isInitialLoad
          ? _buildLoadingState()
          : _errorMessage != null
          ? _buildErrorState(_errorMessage!)
          : Padding(
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
                                color: selected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.2,
                                          ),
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
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List with StreamBuilder
                  Expanded(
                    child: StreamBuilder<List<DuesPayment>>(
                      stream: _duesService.getPendingPayments(
                        rt: _filterRt == 'Semua' ? null : _filterRt,
                      ),
                      builder: (context, snapshot) {
                        // Handle loading state
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Handle error state
                        if (snapshot.hasError) {
                          return _buildErrorState(
                            'Gagal memuat data: ${snapshot.error}',
                          );
                        }

                        // Handle data
                        final payments = snapshot.data ?? [];

                        if (payments.isEmpty) {
                          return _buildEmptyState();
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            // Trigger rebuild by changing state
                            setState(() {});
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: payments.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (ctx, i) {
                              final payment = payments[i];
                              final paymentMap = {
                                'name': payment.userName,
                                'rt': 'RT ${payment.rt}',
                                'month': payment.month,
                                'amount':
                                    'Rp ${payment.amount.toStringAsFixed(0)}',
                                'date':
                                    '${payment.createdAt.day}/${payment.createdAt.month}/${payment.createdAt.year}',
                              };
                              return PaymentVerificationCard(
                                payment: paymentMap,
                                onTap: () => _openPaymentDetail(payment),
                              );
                            },
                          ),
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
