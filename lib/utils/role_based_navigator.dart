import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/pages/admin/admin_home_screen.dart';
import 'package:rukunin/pages/community_head/community_head_home_screen.dart';
import 'package:rukunin/pages/block_leader/block_leader_home_screen.dart';
import 'package:rukunin/pages/resident/resident_home_screen.dart';
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';

class RoleBasedNavigator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user role from Firestore
  static Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }

  /// Navigate to home screen based on user role
  static Future<void> navigateToRoleBasedHome(
    BuildContext context, {
    bool replace = true,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }

    final role = await getUserRole(user.uid);

    if (!context.mounted) return;

    Widget homeScreen;

    switch (role) {
      case 'admin':
        homeScreen = const AdminHomeScreen();
        break;
      case 'community_head':
        homeScreen = const CommunityHeadHomeScreen();
        break;
      case 'block_leader':
        homeScreen = const BlockLeaderHomeScreen();
        break;
      case 'secretary':
        homeScreen = const SecretaryHomeScreen();
        break;
      case 'treasurer':
        homeScreen = const TreasurerHomeScreen();
        break;
      case 'resident':
      default:
        homeScreen = const ResidentHomeScreen();
        break;
    }

    if (replace) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homeScreen),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homeScreen),
      );
    }
  }

  /// Get home screen widget based on role (for initial route)
  static Future<Widget> getHomeScreenByRole(String uid) async {
    final role = await getUserRole(uid);

    switch (role) {
      case 'admin':
        return const AdminHomeScreen();
      case 'community_head':
        return const CommunityHeadHomeScreen();
      case 'block_leader':
        return const BlockLeaderHomeScreen();
      case 'secretary':
        return const SecretaryHomeScreen();
      case 'treasurer':
        return const TreasurerHomeScreen();
      case 'resident':
      default:
        return const ResidentHomeScreen();
    }
  }
}