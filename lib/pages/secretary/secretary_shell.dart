import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/style/app_colors.dart';

class SecretaryShell extends StatelessWidget {
  final Widget child;

  const SecretaryShell({required this.child, super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/secretary') return 0;
    if (location == '/secretary/account') return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/secretary');
        break;
      case 1:
        // TODO: Navigate to marketplace when available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Menu pasar belum tersedia'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 2:
        // TODO: Navigate to events when available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Menu kegiatan belum tersedia'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 3:
        // TODO: Navigate to administration when available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Menu administrasi belum tersedia'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 4:
        context.go('/secretary/account');
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
                    icon: Icons.description,
                    label: 'Administrasi',
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
