import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class FormFieldsCard extends StatelessWidget {
  final String? source;
  final ValueChanged<String?> onSourceChanged;
  final TextEditingController amountCtrl;
  final DateTime? pickedDate;
  final VoidCallback onPickDate;

  const FormFieldsCard({
    required this.source,
    required this.onSourceChanged,
    required this.amountCtrl,
    required this.pickedDate,
    required this.onPickDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: source,
              decoration: buildInputDecoration('Sumber Pemasukan'),
              items: const [
                DropdownMenuItem(
                  value: 'bantuan',
                  child: Text('Bantuan / Hibah'),
                ),
                DropdownMenuItem(
                  value: 'donasi',
                  child: Text('Donasi Kegiatan'),
                ),
                DropdownMenuItem(
                  value: 'lainnya',
                  child: Text('Pendapatan Lain'),
                ),
              ],
              onChanged: onSourceChanged,
              validator: (v) => v == null ? 'Pilih sumber pemasukan' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: buildInputDecoration('Nominal (Rp)'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Masukkan nominal';
                final parsed = int.tryParse(v.replaceAll(',', ''));
                if (parsed == null || parsed <= 0) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onPickDate,
              child: InputDecorator(
                decoration: buildInputDecoration('Tanggal'),
                child: Text(
                  pickedDate == null
                      ? 'Pilih tanggal'
                      : '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
