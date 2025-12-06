import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const DismissBackground({
    this.icon = Icons.delete,
    this.label = 'Hapus',
    this.color = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
