import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/services/user_cache_service.dart';

class AccountService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> loadUserData() async {
    try {
      // Try loading from cache first
      final cachedData = await UserCacheService().getUserData();
      if (cachedData != null) return cachedData;

      // If no cache, fetch from Firebase
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;

      // Add auth data
      data['email'] = user.email ?? data['email'];
      data['displayName'] = user.displayName ?? data['name'];
      data['uid'] = user.uid;
      data['photoURL'] = user.photoURL;

      // Convert Timestamp to String for caching
      _convertTimestampsToStrings(data);

      // Cache the data
      await UserCacheService().saveUserData(data);

      return data;
    } catch (e) {
      throw Exception('Error loading user data: $e');
    }
  }

  Future<void> saveUserData({
    required String name,
    required String nickname,
    required String gender,
    DateTime? birthdate,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // Prepare update data
      final updateData = {
        'name': name,
        'nickname': nickname,
        'gender': gender,
        'birthdate': birthdate != null ? Timestamp.fromDate(birthdate) : null,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update user data in Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Update cache
      final cachedData = await UserCacheService().getUserData() ?? {};
      cachedData['name'] = name;
      cachedData['nickname'] = nickname;
      cachedData['gender'] = gender;
      cachedData['birthdate'] = birthdate?.toIso8601String();
      cachedData['updatedAt'] = DateTime.now().toIso8601String();

      await UserCacheService().saveUserData(cachedData);
    } catch (e) {
      throw Exception('Error saving user data: $e');
    }
  }

  Future<void> logout() async {
    try {
      await UserCacheService().clearUserData();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }

  void _convertTimestampsToStrings(Map<String, dynamic> data) {
    if (data['birthdate'] is Timestamp) {
      data['birthdate'] = (data['birthdate'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
  }
}
