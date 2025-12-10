import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/modules/auth/models/form_data.dart';
import 'package:rukunin/services/user_cache_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserCacheService _cacheService = UserCacheService();

  Future<UserCredential> signIn(SignInFormData formData) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: formData.email,
      password: formData.password,
    );

    await _cacheUserData(userCredential);
    return userCredential;
  }

  Future<UserCredential> signUp(SignUpFormData formData) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: formData.email,
      password: formData.password,
    );

    await userCredential.user?.updateDisplayName(formData.name);
    await _createUserDocument(userCredential, formData);
    return userCredential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _cacheUserData(UserCredential userCredential) async {
    final userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;

      userData.updateAll((key, value) {
        if (value is Timestamp) {
          return value.toDate().toIso8601String();
        }
        return value;
      });

      userData['email'] = userCredential.user!.email ?? userData['email'];
      userData['displayName'] =
          userCredential.user!.displayName ?? userData['name'];
      userData['uid'] = userCredential.user!.uid;
      userData['photoURL'] = userCredential.user!.photoURL;

      await _cacheService.saveUserData(userData);
    }
  }

  Future<void> _createUserDocument(
    UserCredential userCredential,
    SignUpFormData formData,
  ) async {
    final firestoreData = {
      'name': formData.name,
      'email': formData.email,
      'role': 'resident',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(userCredential.user?.uid)
        .set(firestoreData);

    final cachedData = {
      'name': formData.name,
      'email': formData.email,
      'role': 'resident',
      'uid': userCredential.user!.uid,
      'displayName': formData.name,
      'photoURL': userCredential.user?.photoURL,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _cacheService.saveUserData(cachedData);
  }
}
