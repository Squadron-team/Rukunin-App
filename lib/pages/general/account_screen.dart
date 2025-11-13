import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/pages/general/sign_in_screen.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/pages/community_head/community_head_layout.dart';
import 'package:rukunin/pages/block_leader/block_leader_layout.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/pages/secretary/secretary_layout.dart';
import 'package:rukunin/pages/treasurer/treasurer_layout.dart';
import 'package:rukunin/services/user_cache_service.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Try loading from cache first
      final cachedData = await UserCacheService().getUserData();

      if (cachedData != null) {
        setState(() {
          _displayName = cachedData['name'] ?? cachedData['displayName'] ?? '';
          _email = cachedData['email'] ?? '';
          _userRole = cachedData['role'] ?? 'resident';
          _nameController.text = cachedData['name'] ?? '';
          _nicknameController.text = cachedData['nickname'] ?? '';
          _selectedGender = cachedData['gender'] ?? 'Laki-laki';

          if (cachedData['birthdate'] != null) {
            if (cachedData['birthdate'] is String) {
              try {
                _selectedBirthdate = DateTime.parse(cachedData['birthdate']);
                _birthdateController.text = DateFormat(
                  'dd MMMM yyyy',
                  'id_ID',
                ).format(_selectedBirthdate!);
              } catch (e) {
                _birthdateController.text = cachedData['birthdate'];
              }
            }
          }

          _isLoading = false;
        });
        return; // Return early if cache exists
      }

      // If no cache, fetch from Firebase
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;

        // Add auth data
        data['email'] = user.email ?? data['email'];
        data['displayName'] = user.displayName ?? data['name'];
        data['uid'] = user.uid;
        data['photoURL'] = user.photoURL;

        // Convert Timestamp to String for caching
        if (data['birthdate'] is Timestamp) {
          data['birthdate'] = (data['birthdate'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] = (data['updatedAt'] as Timestamp)
              .toDate()
              .toIso8601String();
        }

        // Cache the data
        await UserCacheService().saveUserData(data);

        setState(() {
          _displayName = data['name'] ?? user.displayName ?? '';
          _email = user.email ?? '';
          _userRole = data['role'] ?? 'resident';
          _nameController.text = data['name'] ?? '';
          _nicknameController.text = data['nickname'] ?? '';
          _selectedGender = data['gender'] ?? 'Laki-laki';

          if (data['birthdate'] != null) {
            try {
              _selectedBirthdate = DateTime.parse(data['birthdate']);
              _birthdateController.text = DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(_selectedBirthdate!);
            } catch (e) {
              _birthdateController.text = data['birthdate'];
            }
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _saveUserData() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nama lengkap tidak boleh kosong'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Update display name in Firebase Auth
      await user.updateDisplayName(_nameController.text.trim());

      // Prepare update data
      final updateData = {
        'name': _nameController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'gender': _selectedGender,
        'birthdate': _selectedBirthdate != null
            ? Timestamp.fromDate(_selectedBirthdate!)
            : null,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update user data in Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Update cache
      final cachedData = await UserCacheService().getUserData() ?? {};
      cachedData['name'] = _nameController.text.trim();
      cachedData['nickname'] = _nicknameController.text.trim();
      cachedData['gender'] = _selectedGender;
      cachedData['birthdate'] = _selectedBirthdate?.toIso8601String();
      cachedData['updatedAt'] = DateTime.now().toIso8601String();

      await UserCacheService().saveUserData(cachedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // Reload user data
      await _loadUserData();
    } catch (e) {
      debugPrint('Error saving user data: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      // Clear cached user data
      await UserCacheService().clearUserData();

      // Sign out from Firebase
      await _auth.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error logging out: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal keluar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'community_head':
        return 'Ketua RT';
      case 'block_leader':
        return 'Ketua RW';
      case 'secretary':
        return 'Sekretaris';
      case 'treasurer':
        return 'Bendahara';
      case 'resident':
      default:
        return 'Warga';
    }
  }

  Widget _buildRoleBasedLayout(Widget body) {
    switch (_userRole) {
      case 'admin':
        return AdminLayout(title: 'Akun', currentIndex: 3, body: body);
      case 'community_head':
        return CommunityHeadLayout(title: 'Akun', currentIndex: 3, body: body);
      case 'block_leader':
        return BlockLeaderLayout(title: 'Akun', currentIndex: 3, body: body);
      case 'secretary':
        return SecretaryLayout(title: 'Akun', currentIndex: 3, body: body);
      case 'treasurer':
        return TreasurerLayout(title: 'Akun', currentIndex: 3, body: body);
      case 'resident':
      default:
        return ResidentLayout(title: 'Akun', currentIndex: 4, body: body);
    }
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _buildRoleBasedLayout(
      SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Picture with Edit Button
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          border: Border.all(
                            color: AppColors.primary,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _auth.currentUser?.photoURL != null
                              ? Image.network(
                                  _auth.currentUser!.photoURL!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[500],
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[500],
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement change profile picture
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Fitur ubah foto profil akan segera tersedia',
                                ),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    _displayName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getRoleDisplayName(_userRole),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Profile Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  _buildLabel('Nama lengkap'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Masukkan nama lengkap',
                  ),

                  const SizedBox(height: 20),

                  // Nickname
                  _buildLabel('Nama panggilan'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nicknameController,
                    hintText: 'Masukkan nama panggilan',
                  ),

                  const SizedBox(height: 20),

                  // Gender
                  _buildLabel('Jenis kelamin'),
                  const SizedBox(height: 8),
                  _buildGenderDropdown(),

                  const SizedBox(height: 20),

                  // Birthdate
                  _buildLabel('Tanggal lahir'),
                  const SizedBox(height: 8),
                  _buildDateField(),

                  const SizedBox(height: 32),

                  // Save Button
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
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
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

                  // Settings Section
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings Options
                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () {
                      // TODO: Navigate to change password
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Fitur ubah password akan segera tersedia',
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

                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    onTap: () {
                      // TODO: Navigate to notification settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Fitur pengaturan notifikasi akan segera tersedia',
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

                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan & Dukungan',
                    onTap: () {
                      // TODO: Navigate to help
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Fitur bantuan akan segera tersedia',
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

                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Tentang Aplikasi',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rukunin',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Versi 1.0.0'),
                              SizedBox(height: 16),
                              Text(
                                'Aplikasi manajemen komunitas untuk memudahkan administrasi RT/RW.',
                                style: TextStyle(height: 1.5),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Tutup',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        items: ['Laki-laki', 'Perempuan'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedGender = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthdate ?? DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                ),
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _birthdateController.text.isEmpty
                  ? 'Pilih tanggal lahir'
                  : _birthdateController.text,
              style: TextStyle(
                fontSize: 16,
                color: _birthdateController.text.isEmpty
                    ? Colors.grey[400]
                    : Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _logout(); // Perform logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
