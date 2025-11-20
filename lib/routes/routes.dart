import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/pages/splash_screen.dart';
import 'package:rukunin/routes/rw_routes.dart';
import 'package:rukunin/routes/rt_route.dart';
import 'package:rukunin/routes/secretary_routes.dart';
import 'package:rukunin/routes/treasurer_routes.dart';
import 'package:rukunin/utils/role_based_navigator.dart';
import 'package:rukunin/routes/auth_routes.dart';
import 'package:rukunin/routes/admin_routes.dart';
import 'package:rukunin/routes/resident_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/pages/general/notification_screen.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthRoute = state.matchedLocation == '/sign-in' || 
                        state.matchedLocation == '/sign-up';
    final isOnboardingRoute = state.matchedLocation == '/onboarding';
    final isSplashRoute = state.matchedLocation == '/';

    // Allow splash screen to show without redirect
    if (isSplashRoute) {
      return null;
    }

    // If user is not logged in and not on auth routes, redirect to sign-in
    if (user == null && !isAuthRoute) {
      return '/sign-in';
    }

    // If user is logged in, check if onboarding is completed
    if (user != null && !isAuthRoute && !isOnboardingRoute) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        final onboardingCompleted = userDoc.data()?['onboardingCompleted'] ?? false;
        
        if (!onboardingCompleted) {
          return '/onboarding';
        }
      } catch (e) {
        // If error checking, allow access
        return null;
      }
    }

    // If user is logged in, onboarding completed, and on auth routes, redirect to role-based home
    if (user != null && isAuthRoute) {
      final role = await RoleBasedNavigator.getUserRole(user.uid);
      return RoleBasedNavigator.getRouteByRole(role);
    }

    return null;
  },
  routes: [
    // Splash screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Authentication routes
    ...authRoutes,
    
    // Admin routes
    adminRoutes,

    // RT routes
    rtRoutes,
    
    // RW routes
    rwRoutes,

    // Secretary routes
    secretaryRoutes,

    // Treasurer routes
    treasurerRoutes,
    
    // Resident routes
    residentRoutes,

    // Notification route (accessible by all authenticated users)
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
  ],
);