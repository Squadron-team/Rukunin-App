import 'package:flutter/material.dart';

class ArchiveSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ArchiveSearchBar({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, size: 24),
          hintText: 'Cari arsip...',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
