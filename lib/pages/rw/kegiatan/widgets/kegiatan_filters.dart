import 'package:flutter/material.dart';

class KegiatanFilters extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final Function(String) onStatusChanged;
  final Function() onSearchChanged;

  const KegiatanFilters({
    required this.controller, required this.selectedStatus, required this.onStatusChanged, required this.onSearchChanged, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
      child: Column(
        children: [
          // Search
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              onChanged: (_) => onSearchChanged(),
              decoration: const InputDecoration(
                hintText: 'Cari kegiatan...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Status Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                statusChip('Semua', Colors.red),
                statusChip('Akan Datang', Colors.blue),
                statusChip('Sedang Berlangsung', Colors.green),
                statusChip('Selesai', Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String label, Color color) {
    final isSelected = selectedStatus == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w700,
          ),
        ),
        selected: isSelected,
        selectedColor: color,
        backgroundColor: Colors.white,
        onSelected: (_) => onStatusChanged(label),
      ),
    );
  }
}
