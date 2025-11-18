import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

InputDecoration buildInputDecoration(String label) {
  final borderRadius = BorderRadius.circular(14);
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.grey[800]),
    filled: true,
    fillColor: Colors.grey.shade50,
    errorStyle: const TextStyle(color: Colors.red),
    enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: Colors.grey.shade300)),
    focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: AppColors.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 2)),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );
}
