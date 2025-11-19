import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/resident/resident_home_screen.dart';
import 'package:rukunin/pages/resident/marketplace/marketplace_screen.dart';
import 'package:rukunin/pages/resident/events/events_screen.dart';
import 'package:rukunin/pages/resident/dues/dues_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/resident/resident_shell.dart';

final residentRoutes = ShellRoute(
  builder: (context, state, child) => ResidentShell(child: child),
  routes: [
    GoRoute(
      path: '/resident',
      name: 'resident-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ResidentHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/marketplace',
      name: 'resident-marketplace',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MarketplaceScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/events',
      name: 'resident-events',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: EventsScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/dues',
      name: 'resident-dues',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: DuesScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/account',
      name: 'resident-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
  ],
);
