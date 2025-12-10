import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final List<String>? itemLabels; // Optional: for displaying translated text
  final IconData icon;
  final void Function(String?) onChanged;

  const CustomDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
    this.itemLabels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use itemLabels if provided, otherwise use items
    final displayLabels = itemLabels ?? items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: value,
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              hint: Text(
                'Pilih $label',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              icon: const SizedBox.shrink(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              menuMaxHeight: 300,
              items: List.generate(items.length, (index) {
                return DropdownMenuItem<String>(
                  value: items[index],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      displayLabels[index],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
              onChanged: onChanged,
              selectedItemBuilder: (BuildContext context) {
                return List.generate(items.length, (index) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      displayLabels[index],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
