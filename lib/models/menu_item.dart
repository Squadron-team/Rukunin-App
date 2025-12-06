import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  MenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badge,
  });
}
