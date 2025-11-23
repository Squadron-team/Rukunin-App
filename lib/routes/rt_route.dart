import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/rt/rt_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_list_screen.dart';
import 'package:rukunin/pages/rt/rt_shell.dart';

final rtRoutes = ShellRoute(
  builder: (context, state, child) => RtShell(child: child),
  routes: [
    GoRoute(
      path: '/rt',
      name: 'rt-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RtHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/rt/warga',
      name: 'rt-warga',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: WargaListScreen(),
      ),
    ),
    GoRoute(
      path: '/rt/account',
      name: 'rt-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
  ],
);