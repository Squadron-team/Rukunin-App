import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'components/summary_row.dart';
import 'components/filters_row.dart';
import 'components/mini_charts.dart';
// 'donut_chart.dart' types are provided by repository and mini_charts; keep import only if needed elsewhere
import 'components/sparkline_painter.dart';
import '../../../repositories/statistik_repository.dart';

class LaporanRTScreen extends StatefulWidget {
  const LaporanRTScreen({Key? key}) : super(key: key);

  @override
  State<LaporanRTScreen> createState() => _LaporanRTScreenState();
}

class _LaporanRTScreenState extends State<LaporanRTScreen> {
  String _periode = 'Bulanan';
  String _wilayah = 'Semua Wilayah';

  final Map<String, int> totals = {
    'Penduduk': 1240,
    'KK': 342,
    'Kelahiran': 18,
    'Kematian': 3,
  };

  Widget _buildWilayahSelector() {
    final wilayahs = ['Semua Wilayah', 'Gang Mawar', 'Gang Melati', 'Gang Dahlia'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.location_on, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            // scrollable chip row
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: wilayahs.map((w) {
                    final isSelected = _wilayah == w;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _wilayah = w),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
                          ),
                          child: Text(
                            w,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // move sample data to repository for cleaner UI
    final repo = ReportRepository();
    final age = repo.getAgeDistribution();
    final gender = repo.getGenderDistribution();
    final marriage = repo.getMarriageStatus();
    final births = repo.getBirths();
    final deaths = repo.getDeaths();
    final mobility = repo.getMobility();
    final houseSegments = repo.getHouseSegments();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Laporan RT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
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
                  // Wilayah selector above analytics
                  _buildWilayahSelector(),

                  // 1) Analitik ringkas (top)
                  SummaryRow(totals: totals),
                  const SizedBox(height: 12),

                  // 2) Period filter (top-right)
                  FiltersRow(
                    periode: _periode,
                    wilayah: _wilayah,
                    onPeriodeChanged: (v) => setState(() => _periode = v ?? 'Bulanan'),
                    onWilayahChanged: (v) => setState(() => _wilayah = v ?? 'Semua Wilayah'),
                  ),
                  const SizedBox(height: 12),

                  // 3) Statistik Demografi 
                  const Text('Statistik Demografi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 2, child: MiniDonutCard(title: 'Distribusi Usia', data: age)),
                    const SizedBox(width: 12),
                    Expanded(flex: 1, child: MiniDonutCard(title: 'Jenis Kelamin', data: gender)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: MiniBarCard(title: 'Status Perkawinan', data: marriage)),
                  ]),
                  const SizedBox(height: 16),

                  // 4) Mobilitas & Kelahiran/Kematian
                  const Text('Mobilitas & Vital', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Mutasi Keluarga', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          TwoBarsChart.fromMobility(
                            mobility: mobility,
                            leftLabel: 'Masuk',
                            rightLabel: 'Keluar',
                            leftColor: Colors.green,
                            rightColor: Colors.redAccent,
                            barHeight: 100,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Kelahiran & Kematian', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Builder(builder: (ctx) {
                            final birthsTotal = births.fold<double>(0, (p, e) => p + e);
                            final deathsTotal = deaths.fold<double>(0, (p, e) => p + e);
                            return TwoBarsChart(
                              leftValue: birthsTotal,
                              rightValue: deathsTotal,
                              leftLabel: 'Kelahiran',
                              rightLabel: 'Kematian',
                              leftColor: Colors.green,
                              rightColor: Colors.redAccent,
                              barHeight: 100,
                            );
                          }),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // 5) Rumah 
                  const Text('Statistik Rumah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Builder(builder: (ctx) {
                          final berpenghuni = houseSegments.isNotEmpty ? houseSegments[0].value : 0.0;
                          final kosong = houseSegments.length > 1 ? houseSegments[1].value : 0.0;
                          final map = {'Berpenghuni': berpenghuni, 'Kosong': kosong};
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Hunian', style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            SizedBox(height: 220, child: MiniDonutCard(title: '', data: map)),
                          ]);
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Builder(builder: (ctx) {
                          final berpenghuni = houseSegments.isNotEmpty ? houseSegments[0].value : 0.0;
                          final kontrak = houseSegments.length > 2 ? houseSegments[2].value : 0.0;
                          final tetap = (berpenghuni - kontrak).clamp(0.0, berpenghuni + kontrak);
                          final map = {'Kontrak': kontrak, 'Tetap': tetap};
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Kepemilikan', style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            SizedBox(height: 220, child: MiniDonutCard(title: '', data: map)),
                          ]);
                        }),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // 6) Aktivitas singkat
                  const Text('Kegiatan & Laporan RT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _activityMiniBars(),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildDownloadButton(),
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
  Widget _activityMiniBars() {
    final labels = ['Surat', 'Laporan', 'Kegiatan'];
    final values = [12, 8, 6];
    final maxv = values.reduce(max);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(labels.length, (i) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(labels[i]),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: (values[i] / maxv) * 80,
                    width: 14,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(values[i].toString(), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFFFBF3C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Placeholder action: show snackbar.
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memulai unduh Laporan RT...')));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.download_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Unduh Laporan RT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

