import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:rukunin/utils/error_handler/biometric_error_handler.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  String? _lastErrorMessage;

  // Get the last error message (if any)
  String? get lastErrorMessage => _lastErrorMessage;

  // Check if device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    // Biometric is not supported on web
    if (kIsWeb) return false;

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      debugPrint('Biometric - canCheck: $canCheck, isSupported: $isSupported');
      return canCheck && isSupported;
    } on PlatformException catch (e) {
      debugPrint('Biometric availability error: $e');
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    // Return empty list on web
    if (kIsWeb) return [];

    try {
      final biometrics = await _auth.getAvailableBiometrics();
      debugPrint('Available biometrics: $biometrics');
      return biometrics;
    } on PlatformException catch (e) {
      debugPrint('Get biometrics error: $e');
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticate() async {
    _lastErrorMessage = null;

    // Always return true on web (bypass authentication)
    if (kIsWeb) return true;

    try {
      debugPrint('Starting biometric authentication...');

      // Check if biometric is available first
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      debugPrint('Can check biometrics: $canCheckBiometrics');
      debugPrint('Device supported: $isDeviceSupported');

      if (!canCheckBiometrics || !isDeviceSupported) {
        debugPrint('Biometric not available on this device');
        _lastErrorMessage = 'Biometrik tidak tersedia di perangkat ini';
        return false;
      }

      final availableBiometrics = await _auth.getAvailableBiometrics();
      debugPrint('Available biometrics: $availableBiometrics');

      if (availableBiometrics.isEmpty) {
        debugPrint('No biometrics enrolled');
        _lastErrorMessage = 'Tidak ada biometrik yang terdaftar';
        return false;
      }

      final result = await _auth.authenticate(
        localizedReason:
            'Silakan autentikasi untuk mengaktifkan keamanan biometrik',
        biometricOnly: false, // Allow PIN/pattern as fallback
        sensitiveTransaction: true,
      );

      debugPrint('Authentication result: $result');
      return result;
    } on LocalAuthException catch (e) {
      BiometricErrorHandler.logError(e);
      _lastErrorMessage = BiometricErrorHandler.getUserFriendlyMessage(e);
      return false;
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.code} - ${e.message}');
      _lastErrorMessage = 'Terjadi kesalahan platform: ${e.message}';
      return false;
    } catch (e) {
      debugPrint('Unexpected authentication error: $e');
      _lastErrorMessage = 'Terjadi kesalahan tidak terduga';
      return false;
    }
  }

  // Check if biometric is enabled in settings
  Future<bool> isBiometricEnabled() async {
    // Always return false on web
    if (kIsWeb) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(_biometricEnabledKey) ?? false;
      debugPrint('Biometric enabled: $enabled');
      return enabled;
    } catch (e) {
      debugPrint('Error checking biometric enabled: $e');
      return false;
    }
  }

  // Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    // Do nothing on web
    if (kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, enabled);
      debugPrint('Biometric set to: $enabled');
    } catch (e) {
      debugPrint('Error setting biometric: $e');
      rethrow;
    }
  }
}
