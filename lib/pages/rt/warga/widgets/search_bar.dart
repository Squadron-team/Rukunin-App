import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

typedef SearchChanged = void Function(String value);

class WargaSearchBar extends StatelessWidget {
  final String hint;
  final SearchChanged onChanged;

  const WargaSearchBar({
    required this.onChanged,
    super.key,
    this.hint = 'Cari warga',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
