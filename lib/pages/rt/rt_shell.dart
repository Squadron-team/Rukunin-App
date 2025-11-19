import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';

class RtShell extends StatelessWidget {
  final Widget child;

  const RtShell({
    required this.child,
    super.key,
  });

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/rt') return 0;
    if (location == '/rt/warga') return 1;
    if (location == '/rt/laporan') return 2;
    if (location == '/rt/account') return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/rt');
        break;
      case 1:
        context.go('/rt/warga');
        break;
      case 2:
        // TODO: Add proper navigation when laporan screen is created
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Menu Laporan belum tersedia'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 3:
        context.go('/rt/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                _buildNavItem(
                  context,
                  icon: Icons.home_rounded,
                  label: 'Dashboard',
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_rounded,
                  label: 'Warga',
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.analytics_rounded,
                  label: 'Laporan',
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_rounded,
                  label: 'Akun',
                  index: 3,
                  isSelected: currentIndex == 3,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
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