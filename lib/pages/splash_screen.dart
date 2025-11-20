import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/role_based_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Navigate after splash animation
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // User is logged in, go to role-based home
      final role = await RoleBasedNavigator.getUserRole(user.uid);
      final route = RoleBasedNavigator.getRouteByRole(role);
      if (mounted) context.go(route);
    } else {
      // User is not logged in, go to sign-in
      if (mounted) context.go('/sign-in');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(38),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'RUKUNIN',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kelola RT/RW Lebih Mudah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withAlpha(176),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
