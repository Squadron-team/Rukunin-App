import 'package:flutter/material.dart';
// theme/colors used inside extracted widgets
import 'package:rukunin/pages/rt/report_statistic/components/sparkline_painter.dart';
import 'package:rukunin/pages/rt/report_statistic/components/mini_charts.dart';
import 'package:rukunin/pages/rt/report_statistic/components/filters_row.dart';
import 'package:rukunin/pages/treasurer/analysis/widgets/analysis_widgets.dart';

class TreasurerAnalysisScreen extends StatefulWidget {
  const TreasurerAnalysisScreen({super.key});

  @override
  State<TreasurerAnalysisScreen> createState() =>
      _TreasurerAnalysisScreenState();
}

// RtFilter and several analysis widgets moved to
// `lib/pages/treasurer/analysis/widgets/treasurer_analysis_widgets.dart` to keep this file small.

class _TreasurerAnalysisScreenState extends State<TreasurerAnalysisScreen> {
  String _selectedPeriod = 'Bulanan';
  String _wilayah = 'Semua Wilayah';

  // Generate dummy
  List<double> _dummySeries(int months, double base, double variance) {
    final rng = DateTime.now().millisecondsSinceEpoch % 100;
    return List.generate(months, (i) {
      final v = base + ((i + rng) % 5) * variance - variance * 2;
      return v < 0 ? base : v;
    });
  }

  // formatting helpers moved to widgets where needed

  Map<String, dynamic> _generateDummyStats() {
    final months = _selectedPeriod == 'Bulanan'
        ? 6
        : _selectedPeriod == 'Triwulan'
        ? 6
        : 12;

    // Cash flow
    final incomes = _dummySeries(months, 12000000, 3000000);
    final expenses = _dummySeries(months, 8000000, 2500000);
    final totalIncome = incomes.fold<double>(0, (p, e) => p + e);
    final totalExpense = expenses.fold<double>(0, (p, e) => p + e);

    // Iuran dummy
    final iuranCategories = ['Oktober', 'November', 'Desember', 'Januari'];
    final iuranData = <String, Map<String, dynamic>>{};
    for (var c in iuranCategories) {
      const target = 50000000.0;
      final collected = (target * (70 + (c.length % 30)) / 100).clamp(
        0,
        target,
      );
      final paidPercent = ((collected / target) * 100).round();
      iuranData[c] = {
        'target': target,
        'collected': collected,
        'paidPercent': paidPercent,
        'unpaidCount': (100 - paidPercent) * 2,
      };
    }

    // unpaid by RT
    final unpaidByRt = {'RT01': 12.0, 'RT02': 8.0, 'RT03': 5.0, 'RT04': 2.0};

    // expenses by category
    final expenseByCategory = {
      'Gaji': 4500000.0,
      'Operasional': 2500000.0,
      'Acara': 3200000.0,
      'Infrastruktur': 1500000.0,
    };

    // incomes by category
    final incomeByCategory = {
      'Iuran': totalIncome * 0.62,
      'Donasi': totalIncome * 0.24,
      'Lain-lain': totalIncome * 0.14,
    };

    // anomalies
    const fakeReceipts = 6;
    final fakeByRt = {'RT01': 3.0, 'RT02': 2.0, 'RT03': 1.0};
    final fakeTrend = _dummySeries(months, 1, 3);

    return {
      'cash': {
        'incomes': incomes,
        'expenses': expenses,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'status': totalIncome >= totalExpense ? 'Surplus' : 'Defisit',
      },
      'iuran': {'categories': iuranData, 'unpaidByRt': unpaidByRt},
      'expenses': {'byCategory': expenseByCategory},
      'income': {'byCategory': incomeByCategory},
      'anomaly': {
        'fakeReceipts': fakeReceipts,
        'fakeByRt': fakeByRt,
        'fakeTrend': fakeTrend,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _generateDummyStats();
    final cash = stats['cash'] as Map<String, dynamic>;
    final iuran = stats['iuran'] as Map<String, dynamic>;
    final expenses = stats['expenses'] as Map<String, dynamic>;
    final anomaly = stats['anomaly'] as Map<String, dynamic>;

    final totalIncome = (cash['totalIncome'] as double).toInt();
    final totalExpense = (cash['totalExpense'] as double).toInt();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Analisis Keuangan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FiltersRow(
                      periode: _selectedPeriod,
                      wilayah: _wilayah,
                      onPeriodeChanged: (v) => setState(
                        () => _selectedPeriod = v ?? _selectedPeriod,
                      ),
                      onWilayahChanged: (v) =>
                          setState(() => _wilayah = v ?? _wilayah),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 1) Cash flow
                  const Text(
                    'Arus Kas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ArusKasCard(
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                    incomeByCategory: Map<String, double>.from(
                      (stats['income']['byCategory'] as Map).map(
                        (k, v) => MapEntry(k, (v as double)),
                      ),
                    ),
                    expenseByCategory: Map<String, double>.from(
                      (expenses['byCategory'] as Map).map(
                        (k, v) => MapEntry(k, (v as double)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2) Analisis Iuran Warga
                  const Text(
                    'Analisis Iuran Warga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  IuranDonutCard(iuran: iuran, totalKk: 245),
                  const SizedBox(height: 12),
                  // Target Iuran
                  const Text(
                    'Target Iuran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  TargetIuranCard(iuran: iuran, totalKk: 245, paidKk: 219),
                  const SizedBox(height: 12),

                  // 4) Anomali / Fraud Detection
                  const Text(
                    'Anomali / Struk Palsu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Struk terdeteksi palsu: ${anomaly['fakeReceipts']}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        MiniBarCard(
                          title: 'RT - Struk Abnormal',
                          data: Map<String, double>.from(
                            anomaly['fakeByRt'] as Map,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: CustomPaint(
                            painter: SparklinePainter(
                              List<double>.from(anomaly['fakeTrend']),
                              Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
