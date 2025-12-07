import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rukunin/services/biometric_auth_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;

  const BiometricLockScreen({required this.child, super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  final BiometricAuthService _biometricService = BiometricAuthService();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  String? _errorMessage;
  bool _shouldLockOnPause = false;

  @override
  void initState() {
    super.initState();
    // Skip biometric check on web
    if (kIsWeb) {
      _isAuthenticated = true;
      return;
    }

    WidgetsBinding.instance.addObserver(this);
    _checkAuthentication();
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Skip on web
    if (kIsWeb) return;

    if (state == AppLifecycleState.paused) {
      // Mark that we should lock when resumed
      _shouldLockOnPause = true;
    } else if (state == AppLifecycleState.resumed) {
      // Only lock if we were actually paused (not just showing auth dialog)
      if (_shouldLockOnPause && _isAuthenticated) {
        setState(() {
          _isAuthenticated = false;
        });
        _checkAuthentication();
        _shouldLockOnPause = false;
      }
    } else if (state == AppLifecycleState.inactive) {
      // Don't lock on inactive - this happens during auth dialog
      // Do nothing here
    }
  }

  Future<void> _checkAuthentication() async {
    // Don't check if already authenticated or currently authenticating
    if (_isAuthenticated || _isAuthenticating) return;

    final isEnabled = await _biometricService.isBiometricEnabled();
    if (!isEnabled) {
      setState(() {
        _isAuthenticated = true;
      });
      return;
    }

    await _authenticate();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final isAuthenticated = await _biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticated = isAuthenticated;
        _isAuthenticating = false;
        if (!isAuthenticated) {
          _errorMessage = _biometricService.lastErrorMessage;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Rukunin Terkunci',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Autentikasi untuk membuka aplikasi',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 48),
            if (_isAuthenticating)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            else
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Autentikasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
