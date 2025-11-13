import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  static String translateErrorMessage(FirebaseAuthException error) {
    String errorMessage;

    switch (error.code) {
      case 'user-not-found':
        errorMessage =
            'Email tidak terdaftar. Silakan buat akun terlebih dahulu.';
        break;
      case 'wrong-password':
        errorMessage = 'Kata sandi salah. Silakan coba lagi.';
        break;
      case 'email-already-in-use':
        errorMessage =
            'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
        break;
      case 'invalid-email':
        errorMessage = 'Format email tidak valid.';
        break;
      case 'user-disabled':
        errorMessage = 'Akun ini telah dinonaktifkan.';
        break;
      case 'too-many-requests':
        errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
        break;
      case 'invalid-credential':
        errorMessage = 'Email atau kata sandi salah.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Operasi tidak diizinkan. Hubungi administrator.';
        break;
      case 'weak-password':
        errorMessage =
            'Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.';
        break;
      default:
        errorMessage = 'Terjadi kesalahan: ${error.message}';
    }

    return errorMessage;
  }
}
