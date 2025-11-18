import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/rw/rw_home_screen.dart';
import 'package:rukunin/pages/rw/data_warga/data_warga_screen.dart';
import 'package:rukunin/pages/rw/laporan/kelola_laporan_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/rw/rw_shell.dart';

final rwRoutes = ShellRoute(
  builder: (context, state, child) => RwShell(child: child),
  routes: [
    GoRoute(
      path: '/rw',
      name: 'rw-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RwHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/rw/warga',
      name: 'rw-warga',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: DataWargaScreen(),
      ),
    ),
    GoRoute(
      path: '/rw/laporan',
      name: 'rw-laporan',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: KelolaLaporanScreen(),
      ),
    ),
    GoRoute(
      path: '/rw/account',
      name: 'rw-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
  ],
);
