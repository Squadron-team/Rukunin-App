import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
    this.icon,
    super.key,
  });

  Color _defaultColor(String label) {
    switch (label.toLowerCase()) {
      case 'sosial':
        return Colors.green;
      case 'rapat':
        return Colors.blue;
      case 'pendidikan':
        return Colors.purple;
      case 'seni':
        return Colors.pink;
      case 'olahraga':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _defaultIcon(String label) {
    switch (label.toLowerCase()) {
      case 'sosial':
        return Icons.people;
      case 'rapat':
        return Icons.meeting_room;
      case 'pendidikan':
        return Icons.school;
      case 'seni':
        return Icons.brush;
      case 'olahraga':
        return Icons.fitness_center;
      default:
        return Icons.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final col = color ?? _defaultColor(label);
    final ic = icon ?? _defaultIcon(label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? col.withOpacity(0.18) : Colors.transparent,
          border: Border.all(color: selected ? col : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ic, size: 16, color: selected ? col : Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? col : Colors.grey.shade800,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
