import 'package:flutter/material.dart';

class FinanceReportChart extends StatelessWidget {
  final List<int> data;

  const FinanceReportChart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: CustomPaint(painter: _LineChartPainter(data)),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    double step = size.width / (data.length - 1);
    double maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();

    for (int i = 0; i < data.length; i++) {
      double x = i * step;
      double y = size.height - (data[i] / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
