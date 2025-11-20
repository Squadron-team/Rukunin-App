import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/secretary/secretary_shell.dart';

final secretaryRoutes = ShellRoute(
  builder: (context, state, child) => SecretaryShell(child: child),
  routes: [
    GoRoute(
      path: '/secretary',
      name: 'secretary-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SecretaryHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/secretary/account',
      name: 'secretary-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
  ],
);
