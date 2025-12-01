import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class LetterTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onSelect;

  const LetterTypeSelector({
    required this.selectedType,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      'Surat Keterangan Domisili',
      'Surat Keterangan Usaha',
      'Surat Pengantar SKCK',
      'Surat Kehilangan',
      'Surat Tidak Mampu',
    ];

    return Column(
      children: types
          .map(
            (type) => GestureDetector(
              onTap: () => onSelect(type),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: selectedType == type
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selectedType == type
                        ? AppColors.primary
                        : Colors.grey[300]!,
                    width: 1.4,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedType == type
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selectedType == type
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedType == type
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
