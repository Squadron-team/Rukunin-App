import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/l10n/app_localizations.dart';

class TreasurerShell extends StatelessWidget {
  final Widget child;

  const TreasurerShell({required this.child, super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/treasurer') return 0;
    if (location == '/treasurer/marketplace') return 1;
    if (location == '/treasurer/activities') return 2;
    if (location == '/treasurer/community') return 3;
    if (location == '/treasurer/account') return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/treasurer');
        break;
      case 1:
        context.go('/treasurer/marketplace');
        break;
      case 2:
        context.go('/treasurer/activities');
        break;
      case 3:
        context.go('/treasurer/community');
        break;
      case 4:
        context.go('/treasurer/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    label: l10n.navHome,
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.store_rounded,
                    label: l10n.navMarketplace,
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.event_rounded,
                    label: l10n.navActivities,
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.groups,
                    label: l10n.navCommunity,
                    index: 3,
                    isSelected: currentIndex == 3,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.person_rounded,
                    label: l10n.navAccount,
                    index: 4,
                    isSelected: currentIndex == 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey[600],
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
