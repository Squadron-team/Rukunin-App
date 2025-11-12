import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget icon;
  final Color textColor;

  const SocialSignInButton({
    required this.label,
    required this.icon,
    this.onPressed,
    super.key,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
