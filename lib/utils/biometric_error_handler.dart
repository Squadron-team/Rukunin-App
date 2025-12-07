import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class BiometricErrorHandler {
  static String getUserFriendlyMessage(LocalAuthException e) {
    switch (e.code) {
      case LocalAuthExceptionCode.noBiometricHardware:
        return 'Perangkat Anda tidak mendukung biometrik';

      case LocalAuthExceptionCode.noBiometricsEnrolled:
        return 'Tidak ada sidik jari atau face ID yang terdaftar. Silakan atur di pengaturan perangkat';

      case LocalAuthExceptionCode.noCredentialsSet:
        return 'Tidak ada PIN, pola, atau password yang diatur di perangkat';

      case LocalAuthExceptionCode.userCanceled:
        return 'Autentikasi dibatalkan';

      case LocalAuthExceptionCode.systemCanceled:
        return 'Autentikasi dibatalkan oleh sistem';

      case LocalAuthExceptionCode.temporaryLockout:
        return 'Terlalu banyak percobaan gagal. Coba lagi sebentar';

      case LocalAuthExceptionCode.biometricLockout:
        return 'Biometrik terkunci. Gunakan PIN/pola/password perangkat untuk membuka kunci';

      case LocalAuthExceptionCode.authInProgress:
        return 'Autentikasi sedang berlangsung';

      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        return 'Perangkat biometrik sementara tidak tersedia';

      case LocalAuthExceptionCode.deviceError:
        return 'Terjadi kesalahan pada perangkat';

      case LocalAuthExceptionCode.timeout:
        return 'Waktu autentikasi habis';

      case LocalAuthExceptionCode.uiUnavailable:
        return 'Antarmuka autentikasi tidak tersedia';

      case LocalAuthExceptionCode.userRequestedFallback:
        return 'Pengguna memilih metode autentikasi alternatif';

      case LocalAuthExceptionCode.unknownError:
      default:
        return 'Terjadi kesalahan tidak dikenal';
    }
  }

  static void logError(LocalAuthException e) {
    debugPrint('LocalAuthException: ${e.code.name}');

    switch (e.code) {
      case LocalAuthExceptionCode.noBiometricHardware:
        debugPrint('No biometric hardware available on device');
        break;

      case LocalAuthExceptionCode.noBiometricsEnrolled:
        debugPrint('No biometrics enrolled on device');
        break;

      case LocalAuthExceptionCode.noCredentialsSet:
        debugPrint('No device credentials (PIN/pattern/password) set');
        break;

      case LocalAuthExceptionCode.userCanceled:
        debugPrint('User canceled authentication');
        break;

      case LocalAuthExceptionCode.systemCanceled:
        debugPrint('System canceled authentication');
        break;

      case LocalAuthExceptionCode.temporaryLockout:
        debugPrint('Temporarily locked due to too many failed attempts');
        break;

      case LocalAuthExceptionCode.biometricLockout:
        debugPrint('Biometric locked out - device credentials required');
        break;

      case LocalAuthExceptionCode.authInProgress:
        debugPrint('Authentication already in progress');
        break;

      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        debugPrint('Biometric hardware temporarily unavailable');
        break;

      case LocalAuthExceptionCode.deviceError:
        debugPrint('Device error occurred');
        break;

      case LocalAuthExceptionCode.timeout:
        debugPrint('Authentication timeout');
        break;

      case LocalAuthExceptionCode.uiUnavailable:
        debugPrint('Authentication UI unavailable');
        break;

      case LocalAuthExceptionCode.userRequestedFallback:
        debugPrint('User requested fallback authentication method');
        break;

      case LocalAuthExceptionCode.unknownError:
      default:
        debugPrint('Unknown error: ${e.description}');
        break;
    }
  }

  static bool shouldRetry(LocalAuthException e) {
    return e.code == LocalAuthExceptionCode.userCanceled ||
        e.code == LocalAuthExceptionCode.systemCanceled ||
        e.code == LocalAuthExceptionCode.timeout ||
        e.code == LocalAuthExceptionCode.authInProgress;
  }

  static bool isPermanentError(LocalAuthException e) {
    return e.code == LocalAuthExceptionCode.noBiometricHardware ||
        e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
        e.code == LocalAuthExceptionCode.noCredentialsSet;
  }
}
