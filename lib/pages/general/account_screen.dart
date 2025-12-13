import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:rukunin/widgets/profile_header.dart';
import 'package:rukunin/widgets/form_field_with_label.dart';
import 'package:rukunin/widgets/setting_item.dart';
import 'package:rukunin/widgets/dialogs/logout_dialog.dart';
import 'package:rukunin/widgets/dialogs/about_app_dialog.dart';
import 'package:rukunin/services/account_service.dart';
import 'package:rukunin/utils/role_helper.dart';
import 'package:rukunin/services/biometric_auth_service.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/main.dart' show localeService;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:rukunin/widgets/version_text.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;
  final _accountService = AccountService();
  final _biometricService = BiometricAuthService();

  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _birthdateController = TextEditingController();
  String _selectedGender = 'male'; // Changed from 'Laki-laki' to 'male'

  bool _isLoading = true;
  bool _isSaving = false;
  String _userRole = 'resident';
  String _displayName = '';
  String _email = '';
  DateTime? _selectedBirthdate;

  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBiometricSettings();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _accountService.loadUserData();

      if (data != null && mounted) {
        setState(() {
          _displayName = data['name'] ?? data['displayName'] ?? '';
          _email = data['email'] ?? '';
          _userRole = data['role'] ?? 'resident';
          _nameController.text = data['name'] ?? '';
          _nicknameController.text = data['nickname'] ?? '';

          // Convert stored value to key if needed
          final gender = data['gender'] ?? 'male';
          if (gender == 'Laki-laki' || gender == 'male') {
            _selectedGender = 'male';
          } else if (gender == 'Perempuan' || gender == 'female') {
            _selectedGender = 'female';
          } else {
            _selectedGender = 'male';
          }

          if (data['birthdate'] != null) {
            _parseBirthdate(data['birthdate']);
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Gagal memuat data: $e');
    }
  }

  void _parseBirthdate(dynamic birthdate) {
    try {
      if (birthdate is String) {
        _selectedBirthdate = DateTime.parse(birthdate);
        _birthdateController.text = DateFormat(
          'dd MMMM yyyy',
          'id_ID',
        ).format(_selectedBirthdate!);
      }
    } catch (e) {
      _birthdateController.text = birthdate.toString();
    }
  }

  Future<void> _saveUserData() async {
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty) {
      _showWarningSnackBar(l10n.fullNameRequired);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Save gender as key, not translated text
      await _accountService.saveUserData(
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        gender: _selectedGender, // Save 'male' or 'female'
        birthdate: _selectedBirthdate,
      );

      if (mounted) {
        _showSuccessSnackBar(l10n.profileUpdatedSuccess);
        await _loadUserData();
      }
    } catch (e) {
      _showErrorSnackBar(l10n.failedToSaveData(e.toString()));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await _accountService.logout();
      if (mounted) context.go('/sign-in');
    } catch (e) {
      _showErrorSnackBar(l10n.failedToLogout(e.toString()));
    }
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = DateFormat(
          'dd MMMM yyyy',
          'id_ID',
        ).format(picked);
      });
    }
  }

  Future<void> _loadBiometricSettings() async {
    if (kIsWeb) {
      setState(() {
        _isBiometricEnabled = false;
        _isBiometricAvailable = false;
      });
      return;
    }

    final isEnabled = await _biometricService.isBiometricEnabled();
    final isAvailable = await _biometricService.isBiometricAvailable();

    if (mounted) {
      setState(() {
        _isBiometricEnabled = isEnabled;
        _isBiometricAvailable = isAvailable;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      if (value) {
        final isAvailable = await _biometricService.isBiometricAvailable();
        if (!isAvailable) {
          _showErrorSnackBar(l10n.biometricNotAvailable);
          return;
        }

        final biometrics = await _biometricService.getAvailableBiometrics();
        if (biometrics.isEmpty) {
          _showErrorSnackBar(l10n.noBiometricEnrolled);
          return;
        }

        final authenticated = await _biometricService.authenticate();
        if (!authenticated) {
          final errorMessage =
              _biometricService.lastErrorMessage ??
              l10n.authenticationCancelled;
          _showWarningSnackBar(errorMessage);
          return;
        }
      }

      await _biometricService.setBiometricEnabled(value);

      if (mounted) {
        setState(() {
          _isBiometricEnabled = value;
        });

        _showSuccessSnackBar(
          value ? l10n.biometricEnabled : l10n.biometricDisabled,
        );
      }
    } catch (e) {
      debugPrint('Toggle biometric error: $e');
      _showErrorSnackBar(l10n.errorOccurredBiometric(e.toString()));
      if (mounted) {
        setState(() {
          _isBiometricEnabled = !value;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) =>
      _showSnackBar(message, Colors.green);
  void _showWarningSnackBar(String message) =>
      _showSnackBar(message, Colors.orange);
  void _showErrorSnackBar(String message) => _showSnackBar(message, Colors.red);

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showComingSoonSnackBar(String feature) {
    final l10n = AppLocalizations.of(context)!;
    _showWarningSnackBar(l10n.featureComingSoon(feature));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.account,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              photoUrl: _auth.currentUser?.photoURL,
              displayName: _displayName,
              email: _email,
              roleDisplayName: RoleHelper.getDisplayName(_userRole),
              onEditPhoto: () => _showComingSoonSnackBar(l10n.editProfilePhoto),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormFieldWithLabel(
                    label: l10n.fullNameLabel,
                    child: CustomTextField(
                      controller: _nameController,
                      hintText: l10n.enterFullName,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: l10n.nicknameLabel,
                    child: CustomTextField(
                      controller: _nicknameController,
                      hintText: l10n.enterNickname,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: l10n.genderLabel,
                    child: CustomDropdown(
                      value: _selectedGender,
                      items: const ['male', 'female'], // Use keys
                      itemLabels: [
                        l10n.male,
                        l10n.female,
                      ], // Display translated labels
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: l10n.birthdateLabel,
                    child: CustomDateField(
                      controller: _birthdateController,
                      onTap: _selectBirthdate,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: LoadingIndicator(),
                            )
                          : Text(
                              l10n.saveChanges,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.settings,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SettingItem(
                    icon: Icons.language,
                    title: l10n.language,
                    subtitle: l10n.languageSubtitle,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: localeService.locale.languageCode,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          dropdownColor: Colors.white,
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(l10n.english),
                            ),
                            DropdownMenuItem(
                              value: 'id',
                              child: Text(l10n.indonesian),
                            ),
                            DropdownMenuItem(
                              value: 'jv',
                              child: Text(l10n.javanese),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value != null) {
                              localeService.setLocale(Locale(value));
                              _showSuccessSnackBar(
                                l10n.languageChangedSuccess(
                                  localeService.getLanguageName(value),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SettingItem(
                    icon: Icons.lock_outline,
                    title: l10n.changePassword,
                    onTap: () =>
                        _showComingSoonSnackBar(l10n.changePasswordFeature),
                  ),
                  SettingItem(
                    icon: Icons.fingerprint,
                    title: l10n.biometricAuth,
                    subtitle: _isBiometricAvailable
                        ? l10n.biometricAuthDesc
                        : kIsWeb
                        ? l10n.biometricNotAvailableWeb
                        : l10n.biometricNotAvailableDevice,
                    trailing: Switch(
                      value: _isBiometricEnabled,
                      onChanged: _isBiometricAvailable
                          ? _toggleBiometric
                          : null,
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    onTap: () =>
                        _showComingSoonSnackBar(l10n.notificationSettings),
                  ),
                  SettingItem(
                    icon: Icons.help_outline,
                    title: l10n.helpSupport,
                    onTap: () => _showComingSoonSnackBar(l10n.helpFeature),
                  ),
                  SettingItem(
                    icon: Icons.book_outlined,
                    title: l10n.userGuide,
                    onTap: () => context.push('/user-guides'),
                  ),
                  SettingItem(
                    icon: Icons.info_outline,
                    title: l10n.aboutApp,
                    onTap: () => AboutAppDialog.show(context),
                  ),
                  SettingItem(
                    icon: Icons.auto_awesome,
                    title: 'ML Inference (testing feature)',
                    onTap: () => context.push('/ml-inference-test'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => LogoutDialog.show(context, _logout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            l10n.logout,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: AlignmentGeometry.center,
                    child: VersionText(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
