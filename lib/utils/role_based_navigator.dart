import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

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

  /// Get route path based on user role
  static String getRouteByRole(String? role) {
    switch (role) {
      case 'admin':
        return '/admin';
      case 'community_head':
        return '/community-head';
      case 'block_leader':
        return '/block-leader';
      case 'secretary':
        return '/secretary';
      case 'treasurer':
        return '/treasurer';
      case 'resident':
      default:
        return '/resident';
    }
  }

  /// Get account route path based on user role
  static String getAccountRouteByRole(String? role) {
    switch (role) {
      case 'admin':
        return '/admin/account';
      case 'community_head':
        return '/community-head/account';
      case 'block_leader':
        return '/block-leader/account';
      case 'secretary':
        return '/secretary/account';
      case 'treasurer':
        return '/treasurer/account';
      case 'resident':
      default:
        return '/resident/account';
    }
  }

  /// Navigate to home screen based on user role
  static Future<void> navigateToRoleBasedHome(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }

    final role = await getUserRole(user.uid);

    if (!context.mounted) return;

    final route = getRouteByRole(role);
    context.go(route);
  }

  /// Navigate to account screen based on user role
  static Future<void> navigateToAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }

    final role = await getUserRole(user.uid);

    if (!context.mounted) return;

    final route = getAccountRouteByRole(role);
    context.go(route);
  }
}