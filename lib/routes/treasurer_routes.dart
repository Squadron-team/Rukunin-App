import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_shell.dart';

final treasurerRoutes = ShellRoute(
  builder: (context, state, child) => TreasurerShell(child: child),
  routes: [
    GoRoute(
      path: '/treasurer',
      name: 'treasurer-home',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: TreasurerHomeScreen()),
    ),
    GoRoute(
      path: '/treasurer/account',
      name: 'treasurer-account',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AccountScreen()),
    ),
  ],
);
