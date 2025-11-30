import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class AdditionalInfoForm extends StatelessWidget {
  final TextEditingController controller;

  const AdditionalInfoForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: "Keterangan Tambahan",
      controller: controller,
      placeholder: "Contoh: Keperluan administrasi, keperluan sekolah...",
      maxLines: 4,
    );
  }
}
