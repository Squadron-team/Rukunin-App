import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';

final treasurerRoutes = [
  GoRoute(
    path: '/treasurer',
    name: 'treasurer-home',
    builder: (context, state) => const TreasurerHomeScreen(),
  ),
  GoRoute(
    path: '/treasurer/account',
    name: 'treasurer-account',
    builder: (context, state) => const AccountScreen(),
  ),
];