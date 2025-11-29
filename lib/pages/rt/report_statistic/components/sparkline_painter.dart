import 'package:flutter/material.dart';
import 'dart:math';

class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;
  SparklinePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final maxv = points.reduce(max);
    for (var i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = size.height - (points[i] / (maxv == 0 ? 1 : maxv)) * size.height;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TwoBarsChart extends StatelessWidget {
  final double leftValue;
  final double rightValue;
  final String leftLabel;
  final String rightLabel;
  final Color leftColor;
  final Color rightColor;
  final double barHeight;

  const TwoBarsChart({
    Key? key,
    required this.leftValue,
    required this.rightValue,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftColor,
    required this.rightColor,
    this.barHeight = 80.0,
  }) : super(key: key);

  factory TwoBarsChart.fromMobility({
    Key? key,
    required List<double> mobility,
    required String leftLabel,
    required String rightLabel,
    Color leftColor = Colors.green,
    Color rightColor = Colors.redAccent,
    double barHeight = 80.0,
  }) {
    final half = (mobility.length / 2).ceil();
    final masuk = mobility.sublist(0, half).fold<double>(0, (p, e) => p + e);
    final keluar = mobility.sublist(half).fold<double>(0, (p, e) => p + e);
    return TwoBarsChart(
      key: key,
      leftValue: masuk,
      rightValue: keluar,
      leftLabel: leftLabel,
      rightLabel: rightLabel,
      leftColor: leftColor,
      rightColor: rightColor,
      barHeight: barHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxv = [leftValue, rightValue].fold<double>(0, (p, e) => p > e ? p : e);

    Widget bar(double value, Color color, String label) {
      final factor = maxv <= 0 ? 0.0 : (value / maxv).clamp(0.0, 1.0);
      return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(value.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        SizedBox(
          height: barHeight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 24,
              height: barHeight * factor,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]);
    }

    return SizedBox(
      height: barHeight + 64,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child: Center(child: bar(leftValue, leftColor, leftLabel))),
        const SizedBox(width: 24),
        Expanded(child: Center(child: bar(rightValue, rightColor, rightLabel))),
      ]),
    );
  }
}
