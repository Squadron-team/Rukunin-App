import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/community_head/community_head_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';

final communityHeadRoutes = [
  GoRoute(
    path: '/community-head',
    name: 'community-head-home',
    builder: (context, state) => const CommunityHeadHomeScreen(),
  ),
  GoRoute(
    path: '/community-head/account',
    name: 'community-head-account',
    builder: (context, state) => const AccountScreen(),
  ),
];