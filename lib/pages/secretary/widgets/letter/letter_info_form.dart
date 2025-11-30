import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class LetterInfoForm extends StatelessWidget {
  final TextEditingController nomorSurat;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelect;

  const LetterInfoForm({
    super.key,
    required this.nomorSurat,
    required this.selectedDate,
    required this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "Nomor Surat",
          controller: nomorSurat,
          placeholder: "Contoh: 001/SKD/2024",
          validator: (v) => v!.isEmpty ? "Nomor surat tidak boleh kosong" : null,
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) onDateSelect(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? "Pilih Tanggal Surat"
                        : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
