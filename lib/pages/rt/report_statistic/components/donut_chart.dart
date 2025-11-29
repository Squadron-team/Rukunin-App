import 'dart:math';
import 'package:flutter/material.dart';

class Segment {
  final String label;
  final double value;
  final Color color;
  Segment(this.label, this.value, this.color);
}

class DonutChartPainter extends CustomPainter {
  final List<Segment> segments;
  DonutChartPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = min(size.width, size.height) / 2;
    final stroke = radius * 0.28;
    final total = segments.fold<double>(0, (p, e) => p + e.value);
    double start = -pi / 2;

    for (final s in segments) {
      final sweep = (s.value / (total <= 0 ? 1 : total)) * 2 * pi;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius - stroke / 2), start, sweep, false, paint);
      start += sweep;
    }

    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - stroke - 4, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget legendItem({required String label, required String value, required Color color}) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
    const SizedBox(width: 8),
    Text('$label ($value)', style: const TextStyle(fontWeight: FontWeight.w600)),
  ]);
}
