import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/pages/general/onboarding/state/onboarding_state.dart';
import 'package:rukunin/services/user_cache_service.dart';
import 'package:rukunin/utils/role_based_navigator.dart';

class OnboardingService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> submitOnboardingData(
    BuildContext context,
    OnboardingState state,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      final firestoreData = {
        'nik': state.nikController.text.trim(),
        'birthPlace': state.birthPlaceController.text.trim(),
        'birthdate': Timestamp.fromDate(state.birthdate!),
        'gender': state.gender,
        'address': state.addressController.text.trim(),
        'rt': state.rtController.text.trim(),
        'rw': state.rwController.text.trim(),
        'kelurahan': state.kelurahanController.text.trim(),
        'kecamatan': state.kecamatanController.text.trim(),
        'religion': state.religion,
        'maritalStatus': state.maritalStatus,
        'occupation': state.occupation,
        'education': state.education,
        'kkNumber': state.kkNumberController.text.trim(),
        'headOfFamily': state.headOfFamilyController.text.trim(),
        'relationToHead': state.relationToHead,
        'onboardingCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).update(firestoreData);

      final cachedData = {
        'nik': state.nikController.text.trim(),
        'birthPlace': state.birthPlaceController.text.trim(),
        'birthdate': state.birthdate!.toIso8601String(),
        'gender': state.gender,
        'address': state.addressController.text.trim(),
        'rt': state.rtController.text.trim(),
        'rw': state.rwController.text.trim(),
        'kelurahan': state.kelurahanController.text.trim(),
        'kecamatan': state.kecamatanController.text.trim(),
        'religion': state.religion,
        'maritalStatus': state.maritalStatus,
        'occupation': state.occupation,
        'education': state.education,
        'kkNumber': state.kkNumberController.text.trim(),
        'headOfFamily': state.headOfFamilyController.text.trim(),
        'relationToHead': state.relationToHead,
        'onboardingCompleted': true,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final existingData = await UserCacheService().getUserData();
      final updatedData = {...?existingData, ...cachedData};
      await UserCacheService().saveUserData(updatedData);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      await RoleBasedNavigator.navigateToRoleBasedHome(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
