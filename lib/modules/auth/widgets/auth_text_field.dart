import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const AuthTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    super.key,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textCapitalization,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        validator: validator,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(prefixIcon, color: AppColors.primary),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
