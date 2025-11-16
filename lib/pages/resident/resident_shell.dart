import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';

class ResidentShell extends StatelessWidget {
  final Widget child;

  const ResidentShell({required this.child, super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/resident') return 0;
    if (location == '/resident/marketplace') return 1;
    if (location == '/resident/events') return 2;
    if (location == '/resident/dues') return 3;
    if (location == '/resident/account') return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/resident');
        break;
      case 1:
        context.go('/resident/marketplace');
        break;
      case 2:
        context.go('/resident/events');
        break;
      case 3:
        context.go('/resident/dues');
        break;
      case 4:
        context.go('/resident/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

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
                    label: 'Beranda',
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.store_rounded,
                    label: 'Pasar',
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.event_rounded,
                    label: 'Kegiatan',
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.receipt_long_rounded,
                    label: 'Iuran',
                    index: 3,
                    isSelected: currentIndex == 3,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.person_rounded,
                    label: 'Akun',
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
