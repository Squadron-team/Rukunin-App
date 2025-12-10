import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/modules/auth/models/form_data.dart';
import 'package:rukunin/modules/auth/services/google_auth_service.dart';
import 'package:rukunin/services/user_cache_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleAuthService _googleAuthService = GoogleAuthService();
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

  Future<UserCredential?> signInWithGoogle() async {
    final UserCredential userCredential = await _googleAuthService
        .signInWithGoogle();

    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

    if (isNewUser) {
      await _createUserDocument(userCredential);
    } else {
      await _cacheUserData(userCredential);
    }

    return userCredential;
  }

  Future<void> signOutGoogle() async {
    await _googleAuthService.signOut();
  }

  Future<void> _cacheUserData(UserCredential userCredential) async {
    final user = userCredential.user;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

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
    UserCredential userCredential, [
    SignUpFormData? formData,
  ]) async {
    final user = userCredential.user!;

    final name = formData?.name ?? user.displayName ?? 'Unnamed User';
    final email = formData?.email ?? user.email ?? '';

    final firestoreData = {
      'name': name,
      'email': email,
      'role': 'resident',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(userCredential.user?.uid)
        .set(firestoreData);

    final cachedData = {
      'name': name,
      'email': email,
      'role': 'resident',
      'uid': userCredential.user!.uid,
      'displayName': name,
      'photoURL': userCredential.user?.photoURL,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _cacheService.saveUserData(cachedData);
  }
}
