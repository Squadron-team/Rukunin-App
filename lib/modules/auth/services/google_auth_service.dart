import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Returns a Firebase UserCredential (or null if user cancelled).
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Web flow: signInWithPopup returns UserCredential directly
      final provider = GoogleAuthProvider();
      return await _auth.signInWithPopup(provider);
    } else {
      // Mobile flow: use google_sign_in to get tokens then sign into Firebase
      await _googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    }
  }

  Future<void> signOut() async {
    // sign out both firebase and google_sign_in
    await _auth.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
