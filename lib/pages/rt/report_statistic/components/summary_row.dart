import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class SummaryRow extends StatelessWidget {
  final Map<String, int> totals;
  const SummaryRow({Key? key, required this.totals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a responsive two-column layout so tiles are not too narrow.
    return LayoutBuilder(builder: (context, constraints) {
      final spacing = 12.0;
      // make two columns to avoid narrow, tall cards
      final tileWidth = (constraints.maxWidth - spacing) / 2;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          SizedBox(width: tileWidth, child: _summaryTile('Total Penduduk', totals['Penduduk']!.toString(), AppColors.primary)),
          SizedBox(width: tileWidth, child: _summaryTile('Total KK', totals['KK']!.toString(), Colors.indigo)),
          SizedBox(width: tileWidth, child: _summaryTile('Kelahiran', totals['Kelahiran']!.toString(), Colors.green)),
          SizedBox(width: tileWidth, child: _summaryTile('Kematian', totals['Kematian']!.toString(), Colors.redAccent)),
        ],
      );
    });
  }

  Widget _summaryTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Icon(Icons.insert_chart, color: color)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          ]),
        ),
      ]),
    );
  }
}
