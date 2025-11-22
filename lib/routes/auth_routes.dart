import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/general/onboarding/onboarding_screen.dart';
import 'package:rukunin/pages/general/sign_in_screen.dart';
import 'package:rukunin/pages/general/sign_up_screen.dart';

final authRoutes = [
  GoRoute(
    path: '/sign-in',
    name: 'sign-in',
    builder: (context, state) => const SignInScreen(),
  ),
  GoRoute(
    path: '/sign-up',
    name: 'sign-up',
    builder: (context, state) => const SignUpScreen(),
  ),
  GoRoute(
    path: '/onboarding',
    name: 'onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
];
