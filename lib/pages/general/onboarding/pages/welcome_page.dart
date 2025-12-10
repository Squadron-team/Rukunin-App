import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/onboarding/widgets/info_card.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/l10n/app_localizations.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.welcomeToRukunin,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          InfoCard(
            icon: Icons.badge,
            title: l10n.ktpData,
            description: l10n.ktpDataDesc,
          ),
          const SizedBox(height: 16),
          InfoCard(
            icon: Icons.family_restroom,
            title: l10n.kkData,
            description: l10n.kkDataDesc,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.dataVerificationNotice,
                    style: TextStyle(fontSize: 13, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
