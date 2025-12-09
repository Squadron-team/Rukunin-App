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
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

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
  String _selectedGender = 'Laki-laki';

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
          _selectedGender = data['gender'] ?? 'Laki-laki';

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
    if (_nameController.text.trim().isEmpty) {
      _showWarningSnackBar('Nama lengkap tidak boleh kosong');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _accountService.saveUserData(
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        gender: _selectedGender,
        birthdate: _selectedBirthdate,
      );

      if (mounted) {
        _showSuccessSnackBar('Profil berhasil diperbarui');
        await _loadUserData();
      }
    } catch (e) {
      _showErrorSnackBar('Gagal menyimpan data: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    try {
      await _accountService.logout();
      if (mounted) context.go('/sign-in');
    } catch (e) {
      _showErrorSnackBar('Gagal keluar: $e');
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
    try {
      if (value) {
        final isAvailable = await _biometricService.isBiometricAvailable();
        if (!isAvailable) {
          _showErrorSnackBar(
            'Biometrik tidak tersedia. Pastikan perangkat Anda mendukung dan sudah diatur.',
          );
          return;
        }

        final biometrics = await _biometricService.getAvailableBiometrics();
        if (biometrics.isEmpty) {
          _showErrorSnackBar(
            'Tidak ada biometrik yang terdaftar. Silakan atur sidik jari atau face ID di pengaturan perangkat.',
          );
          return;
        }

        final authenticated = await _biometricService.authenticate();
        if (!authenticated) {
          // Use the detailed error message from the service
          final errorMessage =
              _biometricService.lastErrorMessage ??
              'Autentikasi dibatalkan atau gagal. Silakan coba lagi.';
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
          value
              ? 'Autentikasi biometrik diaktifkan'
              : 'Autentikasi biometrik dinonaktifkan',
        );
      }
    } catch (e) {
      debugPrint('Toggle biometric error: $e');
      _showErrorSnackBar('Terjadi kesalahan: $e');
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
    _showWarningSnackBar('Fitur $feature akan segera tersedia');
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun',
          style: TextStyle(
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
              onEditPhoto: () => _showComingSoonSnackBar('ubah foto profil'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormFieldWithLabel(
                    label: 'Nama lengkap',
                    child: CustomTextField(
                      controller: _nameController,
                      hintText: 'Masukkan nama lengkap',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: 'Nama panggilan',
                    child: CustomTextField(
                      controller: _nicknameController,
                      hintText: 'Masukkan nama panggilan',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: 'Jenis kelamin',
                    child: CustomDropdown(
                      value: _selectedGender,
                      items: const ['Laki-laki', 'Perempuan'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFieldWithLabel(
                    label: 'Tanggal lahir',
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
                          : const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SettingItem(
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () => _showComingSoonSnackBar('ubah password'),
                  ),
                  SettingItem(
                    icon: Icons.fingerprint,
                    title: 'Autentikasi Biometrik',
                    subtitle: _isBiometricAvailable
                        ? 'Gunakan sidik jari atau face ID untuk membuka aplikasi'
                        : kIsWeb
                        ? 'Tidak tersedia di platform web'
                        : 'Tidak tersedia di perangkat ini',
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
                    title: 'Notifikasi',
                    onTap: () =>
                        _showComingSoonSnackBar('pengaturan notifikasi'),
                  ),
                  SettingItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan & Dukungan',
                    onTap: () => _showComingSoonSnackBar('bantuan'),
                  ),
                  SettingItem(
                    icon: Icons.book_outlined,
                    title: 'Panduan Pengguna',
                    onTap: () => context.push('/user-guides'),
                  ),
                  SettingItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () => AboutAppDialog.show(context),
                  ),
                  SettingItem(
                    icon: Icons.auto_awesome,
                    title: 'Load ONNX ML model',
                    onTap: () => context.push('/onnx-test'),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
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
