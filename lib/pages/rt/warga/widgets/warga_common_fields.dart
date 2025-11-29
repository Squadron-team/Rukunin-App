import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/widgets/input_decorations.dart';

typedef DateChanged = void Function(DateTime? d);

class AddressPicker extends StatelessWidget {
  final List<Street> streets;
  final Street? selectedStreet;
  final ValueChanged<Street?> onStreetChanged;
  final int? selectedHouseNo;
  final ValueChanged<int?> onHouseChanged;

  const AddressPicker({
    required this.streets,
    required this.selectedStreet,
    required this.onStreetChanged,
    required this.selectedHouseNo,
    required this.onHouseChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<Street>(
          decoration: buildInputDecoration('Jalan'),
          items: streets
              .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
              .toList(),
          initialValue: selectedStreet,
          onChanged: onStreetChanged,
          validator: (v) => v == null ? 'Pilih jalan' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          decoration: buildInputDecoration('Nomor Rumah'),
          items:
              (selectedStreet != null
                      ? List<int>.generate(
                          selectedStreet!.totalHouses > 0
                              ? selectedStreet!.totalHouses
                              : 6,
                          (i) => i + 1,
                        )
                      : <int>[])
                  .map((n) => DropdownMenuItem(value: n, child: Text('No. $n')))
                  .toList(),
          initialValue: selectedHouseNo,
          onChanged: onHouseChanged,
          validator: (v) => v == null ? 'Pilih nomor rumah' : null,
        ),
      ],
    );
  }
}

class PersonalDetailsFields extends StatelessWidget {
  final TextEditingController placeC;
  final DateTime? dateOfBirth;
  final DateChanged onDateChanged;
  final TextEditingController pekerjaanC;
  final TextEditingController maritalC;
  final TextEditingController educationC;
  final bool isHead;
  final ValueChanged<bool> onIsHeadChanged;

  const PersonalDetailsFields({
    required this.placeC,
    required this.dateOfBirth,
    required this.onDateChanged,
    required this.pekerjaanC,
    required this.maritalC,
    required this.educationC,
    required this.isHead,
    required this.onIsHeadChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: isHead,
          onChanged: onIsHeadChanged,
          title: const Text('Kepala Keluarga'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: placeC,
          decoration: buildInputDecoration('Tempat Lahir'),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: dateOfBirth ?? DateTime(1990),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            onDateChanged(picked);
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: buildInputDecoration('Tanggal Lahir').copyWith(
                hintText: dateOfBirth != null
                    ? dateOfBirth!.toLocal().toString().split(' ').first
                    : '',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: pekerjaanC,
          decoration: buildInputDecoration('Pekerjaan'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: maritalC,
          decoration: buildInputDecoration('Status Perkawinan'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: educationC,
          decoration: buildInputDecoration('Pendidikan'),
        ),
      ],
    );
  }
}
