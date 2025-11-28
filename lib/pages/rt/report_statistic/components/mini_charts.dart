import 'package:flutter/material.dart';
import 'donut_chart.dart';
import 'package:rukunin/style/app_colors.dart';

class MiniDonutCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  const MiniDonutCard({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segments = data.entries.map((e) => Segment(e.key, e.value, _pickColor(e.key))).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        // Donut chart on top, legends underneath (smaller font). Legends wrap horizontally and will form multiple rows if needed.
        Center(child: SizedBox(width: 100, height: 100, child: CustomPaint(painter: DonutChartPainter(segments)))),
        const SizedBox(height: 8),
        Center(
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: segments.map((s) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text(s.value.toInt().toString(), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Color _pickColor(String key) {
    switch (key) {
      case 'Anak':
        return Colors.blue;
      case 'Remaja':
        return Colors.purple;
      case 'Dewasa':
        return AppColors.primary;
      case 'Lansia':
        return Colors.redAccent;
      case 'L':
        return Colors.lightBlue;
      case 'P':
        return Colors.pinkAccent;
      case 'Berpenghuni':
        return AppColors.primary;
      case 'Kosong':
        return Colors.grey;
      case 'Kontrak':
        return Colors.orange;
      case 'Tetap':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class MiniBarCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  const MiniBarCard({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = data.values.fold<double>(0, (p, e) => p > e ? p : e);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Column(children: data.entries.map((e) {
          final widthFactor = (max <= 0) ? 0.0 : (e.value / max).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Expanded(flex: 2, child: Text(e.key)),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: Container(decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.9), borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 40, child: Text(e.value.toInt().toString(), textAlign: TextAlign.right)),
            ]),
          );
        }).toList())
      ]),
    );
  }
}
