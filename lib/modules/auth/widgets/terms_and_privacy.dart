import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/l10n/app_localizations.dart';

class TermsAndPrivacy extends StatelessWidget {
  final String? prefix;

  const TermsAndPrivacy({super.key, this.prefix});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
        children: [
          TextSpan(text: prefix ?? l10n.termsPrefix),
          TextSpan(
            text: l10n.termsOfService,
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to terms
              },
          ),
          TextSpan(text: l10n.and),
          TextSpan(
            text: l10n.privacyPolicy,
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to privacy policy
              },
          ),
        ],
      ),
    );
  }
}
