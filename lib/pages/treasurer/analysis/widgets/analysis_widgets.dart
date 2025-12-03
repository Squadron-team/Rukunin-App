import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/pages/rt/report_statistic/components/mini_charts.dart';
import 'package:rukunin/pages/rt/report_statistic/components/donut_chart.dart';

// Reusable RT filter widget (lifted from screen)
class RtFilter extends StatefulWidget {
  final Map<String, dynamic> iuran;
  final ValueChanged<String>? onChanged;
  const RtFilter({required this.iuran, super.key, this.onChanged});

  @override
  State<RtFilter> createState() => _RtFilterState();
}

class _RtFilterState extends State<RtFilter> {
  String _selected = 'Semua';

  @override
  Widget build(BuildContext context) {
    final unpaid = (widget.iuran['unpaidByRt'] as Map?) ?? {};
    final options = ['Semua', ...unpaid.keys.map((k) => k.toString())];
    return DropdownButton<String>(
      value: _selected,
      underline: const SizedBox.shrink(),
      style: const TextStyle(fontWeight: FontWeight.w700),
      items: options
          .map(
            (o) => DropdownMenuItem(
              value: o,
              child: Text(o, style: const TextStyle(color: AppColors.primary)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() => _selected = v);
        if (widget.onChanged != null) widget.onChanged!(v);
      },
    );
  }
}

// Arus Kas card: shows pemasukan/pengeluaran tiles and embedded breakdown donuts
class ArusKasCard extends StatelessWidget {
  final int totalIncome;
  final int totalExpense;
  final Map<String, double> incomeByCategory;
  final Map<String, double> expenseByCategory;
  const ArusKasCard({
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeByCategory,
    required this.expenseByCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(totalIncome),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pemasukan Periode',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.trending_down,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(totalExpense),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pengeluaran Periode',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MiniDonutCard(
            title: 'Pemasukan per Kategori',
            data: incomeByCategory,
          ),
          const SizedBox(height: 12),
          MiniDonutCard(
            title: 'Pengeluaran per Kategori',
            data: expenseByCategory,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int value) {
    var s = value.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write('.');
    }
    final out = buffer.toString();
    return '${value < 0 ? '-' : ''}Rp $out';
  }
}

// Iuran donut + RT filter widget
class IuranDonutCard extends StatelessWidget {
  final Map<String, dynamic> iuran;
  final int totalKk;
  const IuranDonutCard({required this.iuran, super.key, this.totalKk = 245});

  @override
  Widget build(BuildContext context) {
    final cats = (iuran['categories'] as Map<String, dynamic>);
    double totalTarget = 0.0;
    double totalCollected = 0.0;
    for (final v in cats.values) {
      totalTarget += (v['target'] as num).toDouble();
      totalCollected += (v['collected'] as num).toDouble();
    }
    final collectedPercent =
        ((totalCollected / (totalTarget <= 0 ? 1 : totalTarget)) * 100).clamp(
          0.0,
          100.0,
        );
    final segments = [
      Segment('Lunas', collectedPercent, AppColors.success),
      Segment('Belum', 100.0 - collectedPercent, Colors.redAccent),
    ];
    final int lunasCount = ((collectedPercent / 100.0) * totalKk).round();
    final int belumCount = (totalKk - lunasCount).clamp(0, totalKk);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Filter RT: ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              RtFilter(iuran: iuran),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(painter: DonutChartPainter(segments)),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lunas',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${collectedPercent.toInt()}% • $lunasCount KK',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Belum',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(100 - collectedPercent).toInt()}% • $belumCount KK',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Target Iuran styled card
class TargetIuranCard extends StatelessWidget {
  final Map<String, dynamic> iuran;
  final int totalKk;
  final int paidKk;
  const TargetIuranCard({
    required this.iuran,
    super.key,
    this.totalKk = 245,
    this.paidKk = 219,
  });

  @override
  Widget build(BuildContext context) {
    final cats = (iuran['categories'] as Map<String, dynamic>);
    double totalTarget = 0.0;
    double totalCollected = 0.0;
    for (final v in cats.values) {
      totalTarget += (v['target'] as num).toDouble();
      totalCollected += (v['collected'] as num).toDouble();
    }
    final pct = (totalCollected / (totalTarget <= 0 ? 1 : totalTarget)).clamp(
      0.0,
      1.0,
    );
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
        border: Border.all(color: Colors.blue.withOpacity(0.12)),
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
                'Target Iuran Periode',
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
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${totalCollected.toInt()}',
                    style: const TextStyle(
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
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${totalTarget.toInt()}',
                    style: const TextStyle(
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
              value: pct,
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
                '${(pct * 100).toStringAsFixed(1)}% Tercapai',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$paidKk/$totalKk KK',
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
}
