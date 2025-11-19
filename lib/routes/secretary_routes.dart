import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';

final secretaryRoutes = [
  GoRoute(
    path: '/secretary',
    name: 'secretary-home',
    builder: (context, state) => const SecretaryHomeScreen(),
  ),
  GoRoute(
    path: '/secretary/account',
    name: 'secretary-account',
    builder: (context, state) => const AccountScreen(),
  ),
];
