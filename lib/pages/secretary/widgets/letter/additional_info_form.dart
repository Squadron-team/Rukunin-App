import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/letter/custom_text_field.dart';

class AdditionalInfoForm extends StatelessWidget {
  final TextEditingController controller;

  const AdditionalInfoForm({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Keterangan Tambahan',
      controller: controller,
      placeholder: 'Contoh: Keperluan administrasi, keperluan sekolah...',
      maxLines: 4,
    );
  }
}
