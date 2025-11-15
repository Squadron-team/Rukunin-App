import 'package:flutter/material.dart';

class IconMapper {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pendidikan':
        return Icons.school;
      case 'sosial':
        return Icons.people;
      case 'olahraga':
        return Icons.sports_soccer;
      case 'seni':
        return Icons.palette;
      case 'rapat':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }
}