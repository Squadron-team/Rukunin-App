import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.text, this.icon, this.color, {super.key});

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
