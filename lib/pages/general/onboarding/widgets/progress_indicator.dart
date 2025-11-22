import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentPage;

  const OnboardingProgressIndicator({
    required this.currentPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= currentPage
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
