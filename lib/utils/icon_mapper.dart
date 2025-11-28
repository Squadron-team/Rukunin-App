import 'package:flutter/material.dart';

class IconMapper {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
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
      case 'keamanan':
        return Icons.security;
      case 'kesehatan':
        return Icons.health_and_safety;
      case 'lingkungan':
        return Icons.eco;
      case 'keagamaan':
        return Icons.mosque;
      default:
        return Icons.event;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sosial':
        return Colors.blue;
      case 'rapat':
        return Colors.orange;
      case 'pendidikan':
        return Colors.purple;
      case 'seni':
        return Colors.pink;
      case 'olahraga':
        return Colors.green;
      case 'keamanan':
        return Colors.red;
      case 'kesehatan':
        return Colors.teal;
      case 'lingkungan':
        return Colors.lightGreen;
      case 'keagamaan':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
