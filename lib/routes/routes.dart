import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/routes/block_leader_routes.dart';
import 'package:rukunin/routes/community_head_route.dart';
import 'package:rukunin/routes/secretary_routes.dart';
import 'package:rukunin/routes/treasurer_routes.dart';
import 'package:rukunin/utils/role_based_navigator.dart';
import 'package:rukunin/routes/auth_routes.dart';
import 'package:rukunin/routes/admin_routes.dart';
import 'package:rukunin/routes/resident_routes.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthRoute = state.matchedLocation == '/sign-in' || 
                        state.matchedLocation == '/sign-up';

    // If user is not logged in and not on auth routes, redirect to sign-in
    if (user == null && !isAuthRoute) {
      return '/sign-in';
    }

    // If user is logged in and on auth routes, redirect to role-based home
    if (user != null && isAuthRoute) {
      final role = await RoleBasedNavigator.getUserRole(user.uid);
      return RoleBasedNavigator.getRouteByRole(role);
    }

    return null;
  },
  routes: [
    // Authentication routes
    ...authRoutes,
    
    // Admin routes
    ...adminRoutes,

    // Community Head (RW) routes
    ...communityHeadRoutes,
    
    // Block leader (RT) routes
    ...blockLeaderRoutes,

    // Secretary routes
    ...secretaryRoutes,

    // Treasurer routes
    ...treasurerRoutes,
    
    // Resident routes (with shell)
    residentRoutes,
  ],
);