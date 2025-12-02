import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/pages/rt/report_statistic/components/mini_charts.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';

class TreasurerAnalysisScreen extends StatelessWidget {
  const TreasurerAnalysisScreen({super.key});

  Map<String, dynamic> _computeStats() {
    final repo = DataIuranRepository();
    List<dynamic> items = [];
    try {
      items = repo.all();
    } catch (_) {
      items = [];
    }

    final total = items.length;
    int paid = 0;
    final Map<String, int> unpaidByRt = {};
    final Map<String, int> unpaidByFamily = {};

    bool isPaid(dynamic e) {
      if (e is Map) {
        final s = (e['status'] ?? '')?.toString().toLowerCase();
        if (s == 'lunas' || s == 'paid' || (e['paid'] == true)) return true;
      }
      return false;
    }

    for (final e in items) {
      final paidFlag = isPaid(e);
      if (paidFlag) paid++;

      // detect rt key
      String rt = 'Unknown';
      if (e is Map) {
        rt = (e['rt'] ?? e['rw'] ?? e['rtrw'] ?? 'Unknown').toString();
      }

      if (!paidFlag) {
        unpaidByRt[rt] = (unpaidByRt[rt] ?? 0) + 1;

        // family id detection
        String fam = 'Tidak diketahui';
        if (e is Map) {
          fam = (e['no_kk'] ?? e['kk'] ?? e['familyId'] ?? 'Tidak diketahui')
              .toString();
        }
        unpaidByFamily[fam] = (unpaidByFamily[fam] ?? 0) + 1;
      }
    }

    // prepare donut data
    final donut = {
      'Lunas': paid.toDouble(),
      'Belum': (total - paid).toDouble(),
    };

    // simple bar: top 4 RTs with most unpaid
    final rtEntries = unpaidByRt.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final barData = <String, double>{};
    for (var i = 0; i < (rtEntries.length < 4 ? rtEntries.length : 4); i++) {
      barData[rtEntries[i].key] = rtEntries[i].value.toDouble();
    }

    // top families in debt
    final famEntries = unpaidByFamily.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topDefaulters = famEntries.take(5).toList();

    return {
      'total': total,
      'paid': paid,
      'tunggakan': total - paid,
      'donut': donut,
      'barData': barData,
      'topDefaulters': topDefaulters,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _computeStats();

    final donutMap = stats['donut'] as Map<String, double>;
    final barData = stats['barData'] as Map<String, double>;
    final topDefaulters = stats['topDefaulters'] as List<MapEntry<String, int>>;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Analisis Bendahara',
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
                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _summaryTile(
                          'Total Tagihan',
                          stats['total'].toString(),
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryTile(
                          'Terbayar',
                          stats['paid'].toString(),
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _summaryTile(
                          'Tunggakan',
                          stats['tunggakan'].toString(),
                          Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryTile(
                          'RT dengan tunggakan',
                          (barData.keys.length).toString(),
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Charts row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: MiniDonutCard(
                          title: 'Status Pembayaran',
                          data: donutMap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: MiniBarCard(
                          title: 'RT - Tunggakan Teratas',
                          data: barData.isNotEmpty
                              ? barData
                              : {'Tidak ada': 0.0},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Top defaulters
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Penunggak Teratas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (topDefaulters.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Tidak ada data penunggak.',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        else
                          ...topDefaulters.map((e) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(e.key),
                              trailing: Text('${e.value} tagihan'),
                            );
                          }),
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

  Widget _summaryTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(Icons.account_balance_wallet, color: color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
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
