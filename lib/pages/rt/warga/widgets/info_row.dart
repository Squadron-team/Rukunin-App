import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const InfoRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isHighlight ? AppColors.primary : Colors.black,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
