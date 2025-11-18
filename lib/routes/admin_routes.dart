import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/admin/admin_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';

final adminRoutes = [
  GoRoute(
    path: '/admin',
    name: 'admin-home',
    builder: (context, state) => const AdminHomeScreen(),
  ),
  GoRoute(
    path: '/admin/account',
    name: 'admin-account',
    builder: (context, state) => const AccountScreen(),
  ),
];
