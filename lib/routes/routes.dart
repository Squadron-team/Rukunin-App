import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/pages/general/sign_in_screen.dart';
import 'package:rukunin/pages/general/sign_up_screen.dart';
import 'package:rukunin/pages/admin/admin_home_screen.dart';
import 'package:rukunin/pages/community_head/community_head_home_screen.dart';
import 'package:rukunin/pages/block_leader/block_leader_home_screen.dart';
import 'package:rukunin/pages/resident/resident_home_screen.dart';
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';
import 'package:rukunin/utils/role_based_navigator.dart';

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
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/admin',
      name: 'admin-home',
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: '/community-head',
      name: 'community-head-home',
      builder: (context, state) => const CommunityHeadHomeScreen(),
    ),
    GoRoute(
      path: '/block-leader',
      name: 'block-leader-home',
      builder: (context, state) => const BlockLeaderHomeScreen(),
    ),
    GoRoute(
      path: '/secretary',
      name: 'secretary-home',
      builder: (context, state) => const SecretaryHomeScreen(),
    ),
    GoRoute(
      path: '/treasurer',
      name: 'treasurer-home',
      builder: (context, state) => const TreasurerHomeScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'resident-home',
      builder: (context, state) => const ResidentHomeScreen(),
    ),
  ],
);