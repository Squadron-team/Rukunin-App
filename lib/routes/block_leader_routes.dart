import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/block_leader/block_leader_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';

final blockLeaderRoutes = [
  GoRoute(
    path: '/block-leader',
    name: 'block-leader-home',
    builder: (context, state) => const BlockLeaderHomeScreen(),
  ),
  GoRoute(
    path: '/block-leader/account',
    name: 'block-leader-account',
    builder: (context, state) => const AccountScreen(),
  ),
];
