import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/pages/general/sign_in_screen.dart';
import 'package:rukunin/utils/role_based_navigator.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<Widget>(
            future: RoleBasedNavigator.getHomeScreenByRole(snapshot.data!.uid),
            builder: (context, homeSnapshot) {
              if (homeSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (homeSnapshot.hasError) {
                return const Scaffold(
                  body: Center(
                    child: Text('Error loading home screen'),
                  ),
                );
              }

              return homeSnapshot.data ?? const SignInScreen();
            },
          );
        }

        // User is not logged in
        return const SignInScreen();
      },
    );
  }
}