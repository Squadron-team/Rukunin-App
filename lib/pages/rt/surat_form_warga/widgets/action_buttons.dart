import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class RequestActionButtons extends StatelessWidget {
  final bool disabled;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const RequestActionButtons({
    required this.disabled,
    required this.onReject,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: disabled ? null : onReject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tolak'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: disabled ? null : onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Setuju'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
