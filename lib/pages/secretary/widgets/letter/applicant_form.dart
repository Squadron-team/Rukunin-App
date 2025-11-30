import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'custom_dropdown.dart';

class ApplicantForm extends StatelessWidget {
  final TextEditingController namaPemohon;
  final TextEditingController nik;
  final TextEditingController alamat;

  final String? selectedRT;
  final String? selectedRW;
  final Function(String?) onChangeRT;
  final Function(String?) onChangeRW;

  const ApplicantForm({
    super.key,
    required this.namaPemohon,
    required this.nik,
    required this.alamat,
    required this.selectedRT,
    required this.selectedRW,
    required this.onChangeRT,
    required this.onChangeRW,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "Nama Pemohon",
          controller: namaPemohon,
          placeholder: "Masukkan nama lengkap",
          validator: (v) => v!.isEmpty ? "Nama tidak boleh kosong" : null,
        ),

        const SizedBox(height: 14),

        CustomTextField(
          label: "NIK",
          controller: nik,
          placeholder: "Masukkan NIK",
          keyboardType: TextInputType.number,
          validator: (v) =>
              v!.length != 16 ? "NIK harus 16 digit" : null,
        ),

        const SizedBox(height: 14),

        CustomTextField(
          label: "Alamat",
          controller: alamat,
          placeholder: "Masukkan alamat lengkap",
          maxLines: 3,
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                label: "RT",
                value: selectedRT,
                items: List.generate(10, (i) => "0${i + 1}"),
                onChanged: onChangeRT,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: CustomDropdown(
                label: "RW",
                value: selectedRW,
                items: List.generate(10, (i) => "0${i + 1}"),
                onChanged: onChangeRW,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
