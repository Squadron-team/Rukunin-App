import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/modules/auth/models/form_data.dart' show SignInFormData;
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/utils/firebase_auth_helper.dart';
import 'package:rukunin/utils/role_based_navigator.dart';
import 'package:rukunin/widgets/buttons/social_sign_button.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/widgets/language_switcher.dart';
import 'package:rukunin/modules/auth/services/auth_service.dart';
import 'package:rukunin/modules/auth/services/form_validator.dart';
import 'package:rukunin/modules/auth/widgets/auth_header.dart';
import 'package:rukunin/modules/auth/widgets/auth_text_field.dart';
import 'package:rukunin/modules/auth/widgets/terms_and_privacy.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final formData = SignInFormData(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final userCredential = await _authService.signIn(formData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selamat datang, ${userCredential.user?.displayName ?? userCredential.user?.email ?? ""}!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      await RoleBasedNavigator.navigateToRoleBasedHome(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(FirebaseAuthHelper.translateErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan email Anda terlebih dahulu'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Email reset kata sandi telah dikirim. Periksa inbox Anda.',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(FirebaseAuthHelper.translateErrorMessage(e));
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        // User cancelled the sign-in
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNewUser
                ? 'Akun berhasil dibuat! Selamat datang, ${userCredential.user?.displayName ?? userCredential.user?.email ?? ""}!'
                : 'Selamat datang kembali, ${userCredential.user?.displayName ?? userCredential.user?.email ?? ""}!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      if (isNewUser) {
        // Navigate to onboarding for new users
        context.go('/onboarding');
      } else {
        // Navigate to role-based home for existing users
        await RoleBasedNavigator.navigateToRoleBasedHome(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(FirebaseAuthHelper.translateErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Terjadi kesalahan saat masuk dengan Google: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validator = FormValidator(l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthHeader(title: l10n.signIn, subtitle: l10n.signInSubtitle),

                const SizedBox(height: 32),

                AuthTextField(
                  controller: _emailController,
                  hintText: l10n.email,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: validator.validateEmail,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _passwordController,
                  hintText: l10n.password,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: validator.validatePassword,
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: Text(
                      l10n.forgotPassword,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withAlpha(127),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: LoadingIndicator(color: Colors.white),
                          )
                        : Text(l10n.continueButton),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.dontHaveAccount,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () => context.push('/sign-up'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.createAccount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SocialSignInButton(
                  label: l10n.signInWithGoogle,
                  icon: Image.asset(
                    'assets/icons/google_logo.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.g_mobiledata,
                        size: 24,
                        color: Colors.blue,
                      );
                    },
                  ),
                  onPressed: _isLoading ? null : _signInWithGoogle,
                ),

                const SizedBox(height: 24),

                const TermsAndPrivacy(),

                const SizedBox(height: 24),

                const LanguageSwitcher(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
