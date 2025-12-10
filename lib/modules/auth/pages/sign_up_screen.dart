import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/modules/auth/models/form_data.dart' show SignUpFormData;
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/utils/firebase_auth_helper.dart';
import 'package:rukunin/widgets/buttons/social_sign_button.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/widgets/language_switcher.dart';
import 'package:rukunin/modules/auth/services/auth_service.dart';
import 'package:rukunin/modules/auth/services/form_validator.dart';
import 'package:rukunin/modules/auth/widgets/auth_header.dart';
import 'package:rukunin/modules/auth/widgets/auth_text_field.dart';
import 'package:rukunin/modules/auth/widgets/password_requirements.dart';
import 'package:rukunin/modules/auth/widgets/terms_and_privacy.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final formData = SignUpFormData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      await _authService.signUp(formData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Akun berhasil dibuat! Selamat datang, ${formData.name}',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      context.go('/onboarding');
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
                AuthHeader(title: l10n.signUp, subtitle: l10n.signUpSubtitle),

                const SizedBox(height: 32),

                AuthTextField(
                  controller: _nameController,
                  hintText: l10n.fullName,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: validator.validateName,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 16),

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
                  validator: validator.validateStrongPassword,
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

                const SizedBox(height: 8),

                const PasswordRequirements(),

                const SizedBox(height: 8),

                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: l10n.confirmPassword,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => validator.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.5,
                      ),
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
                        : Text(l10n.register),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.alreadyHaveAccount,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.signIn,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'atau',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SocialSignInButton(
                  label: l10n.signUpWithApple,
                  icon: const Icon(Icons.apple, color: Colors.black),
                  onPressed: _isLoading
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.featureNotAvailable(l10n.signUpWithApple),
                              ),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                ),

                const SizedBox(height: 12),

                SocialSignInButton(
                  label: l10n.signUpWithGoogle,
                  icon: Image.network(
                    'https://www.google.com/favicon.ico',
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.featureNotAvailable(l10n.signUpWithGoogle),
                              ),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                ),

                const SizedBox(height: 24),

                TermsAndPrivacy(prefix: l10n.signUpTermsPrefix),

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
