import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/menu_item.dart';

class TreasurerHomeScreen extends StatelessWidget {
  const TreasurerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Beranda', showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const WelcomeRoleCard(
                    greeting: 'Selamat datang kembali!',
                    role: 'Bendahara RW 05',
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 20),
                  _compactStats(context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MenuTabsSection(tabs: _getMenuTabs(context)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _recentActivity(),
            ),
          ],
        ),
      ),
    );
  }

  List<TabData> _getMenuTabs(BuildContext context) {
    return [
      TabData(
        label: 'Iuran',
        icon: Icons.payments_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: 'Data Iuran',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/treasurer/dues'),
            badge: '2',
          ),
          MenuItem(
            label: 'Buat Kwitansi',
            icon: Icons.receipt_rounded,
            onTap: () => context.push('/treasurer/create-receipt'),
          ),
          MenuItem(
            label: 'Riwayat Iuran',
            icon: Icons.history_rounded,
            onTap: () => context.push('/treasurer/dues-history'),
          ),
        ],
      ),
      TabData(
        label: 'Transaksi',
        icon: Icons.receipt_long_rounded,
        items: [
          MenuItem(
            label: 'Riwayat Transaksi',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/treasurer/transaction/history'),
          ),
          MenuItem(
            label: 'Pemasukan',
            icon: Icons.arrow_downward_rounded,
            onTap: () => context.push('/treasurer/incomes'),
          ),
          MenuItem(
            label: 'Pengeluaran',
            icon: Icons.arrow_upward_rounded,
            onTap: () => context.push('/treasurer/expenses'),
          ),
          MenuItem(
            label: 'Mutasi Kas',
            icon: Icons.swap_horiz_rounded,
            onTap: () => context.push('/treasurer/cash-mutation'),
          ),
        ],
      ),
      TabData(
        label: 'Laporan',
        icon: Icons.analytics_rounded,
        items: [
          MenuItem(
            label: 'Ringkasan Bulanan',
            icon: Icons.summarize_rounded,
            onTap: () => context.push('/treasurer/monthly-summary'),
          ),
          MenuItem(
            label: 'Laporan Keuangan',
            icon: Icons.assessment_rounded,
            onTap: () => context.push('/treasurer/financial-reports'),
          ),
          MenuItem(
            label: 'Analisis & Grafik',
            icon: Icons.analytics_rounded,
            onTap: () => context.push('/treasurer/analisis'),
          ),
        ],
      ),
    ];
  }

  Widget _compactStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _compactStatCard(
            'Rp 45.7 Jt',
            'Saldo Kas',
            Icons.account_balance_wallet_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '8/10',
            'Lunas',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _compactStatCard(
            '2',
            'Belum',
            Icons.pending_rounded,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _compactStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _compactActivityItem(
          'Iuran RT 03 - Rp 500.000',
          '10 menit',
          Icons.arrow_downward_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Biaya Kebersihan - Rp 300.000',
          '1 jam',
          Icons.arrow_upward_rounded,
          AppColors.error,
        ),
        const SizedBox(height: 8),
        _compactActivityItem(
          'Iuran RT 07 - Rp 500.000',
          '2 jam',
          Icons.arrow_downward_rounded,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _compactActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
