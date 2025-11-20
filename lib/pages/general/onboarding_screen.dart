import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rukunin/services/user_cache_service.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/role_based_navigator.dart';
import 'package:intl/intl.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  int _currentPage = 0;
  bool _isLoading = false;

  // KTP Data Controllers
  final _nikController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _addressController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();

  // KK Data Controllers
  final _kkNumberController = TextEditingController();
  final _headOfFamilyController = TextEditingController();

  DateTime? _birthdate;
  String? _gender;
  String? _religion;
  String? _maritalStatus;
  String? _occupation;
  String? _education;
  String? _relationToHead;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _religionOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu'
  ];
  final List<String> _maritalStatusOptions = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati'
  ];
  final List<String> _relationOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Menantu',
    'Cucu',
    'Orang Tua',
    'Mertua',
    'Famili Lain',
    'Pembantu',
    'Lainnya'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nikController.dispose();
    _birthPlaceController.dispose();
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kkNumberController.dispose();
    _headOfFamilyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
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
    if (picked != null && picked != _birthdate) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      if (_validateCurrentPage()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentPage() {
    if (_currentPage == 0) {
      // Welcome page - no validation needed
      return true;
    } else if (_currentPage == 1) {
      // KTP validation
      if (_nikController.text.isEmpty ||
          _birthPlaceController.text.isEmpty ||
          _birthdate == null ||
          _gender == null ||
          _addressController.text.isEmpty ||
          _rtController.text.isEmpty ||
          _rwController.text.isEmpty ||
          _kelurahanController.text.isEmpty ||
          _kecamatanController.text.isEmpty ||
          _religion == null ||
          _maritalStatus == null ||
          _occupation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Mohon lengkapi semua data KTP'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return false;
      }
      if (_nikController.text.length != 16) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('NIK harus 16 digit'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return false;
      }
      return true;
    } else if (_currentPage == 2) {
      // KK validation
      if (_kkNumberController.text.isEmpty ||
          _headOfFamilyController.text.isEmpty ||
          _relationToHead == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Mohon lengkapi semua data Kartu Keluarga'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return false;
      }
      if (_kkNumberController.text.length != 16) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Nomor KK harus 16 digit'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return false;
      }
      return true;
    }
    return true;
  }

  Future<void> _submitOnboarding() async {
    if (!_validateCurrentPage()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      // Prepare data for Firestore
      final firestoreData = {
        'nik': _nikController.text.trim(),
        'birthPlace': _birthPlaceController.text.trim(),
        'birthdate': Timestamp.fromDate(_birthdate!),
        'gender': _gender,
        'address': _addressController.text.trim(),
        'rt': _rtController.text.trim(),
        'rw': _rwController.text.trim(),
        'kelurahan': _kelurahanController.text.trim(),
        'kecamatan': _kecamatanController.text.trim(),
        'religion': _religion,
        'maritalStatus': _maritalStatus,
        'occupation': _occupation,
        'education': _education,
        'kkNumber': _kkNumberController.text.trim(),
        'headOfFamily': _headOfFamilyController.text.trim(),
        'relationToHead': _relationToHead,
        'onboardingCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update(firestoreData);

      // Prepare data for cache (use ISO8601 string instead of FieldValue)
      final cachedData = {
        'nik': _nikController.text.trim(),
        'birthPlace': _birthPlaceController.text.trim(),
        'birthdate': _birthdate!.toIso8601String(),
        'gender': _gender,
        'address': _addressController.text.trim(),
        'rt': _rtController.text.trim(),
        'rw': _rwController.text.trim(),
        'kelurahan': _kelurahanController.text.trim(),
        'kecamatan': _kecamatanController.text.trim(),
        'religion': _religion,
        'maritalStatus': _maritalStatus,
        'occupation': _occupation,
        'education': _education,
        'kkNumber': _kkNumberController.text.trim(),
        'headOfFamily': _headOfFamilyController.text.trim(),
        'relationToHead': _relationToHead,
        'onboardingCompleted': true,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Update cached data
      final existingData = await UserCacheService().getUserData();
      final updatedData = {...?existingData, ...cachedData};
      await UserCacheService().saveUserData(updatedData);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate to home
      await RoleBasedNavigator.navigateToRoleBasedHome(context);
    } catch (e) {
      if (!mounted) return;

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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildKTPPage(),
                  _buildKKPage(),
                ],
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lengkapi data kependudukan Anda untuk menggunakan aplikasi Rukunin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildInfoCard(
            Icons.badge,
            'Data KTP',
            'Informasi identitas diri berdasarkan Kartu Tanda Penduduk',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            Icons.family_restroom,
            'Data Kartu Keluarga',
            'Informasi keluarga berdasarkan Kartu Keluarga',
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Data yang Anda masukkan akan diverifikasi oleh pengurus RT/RW',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKTPPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data KTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Kartu Tanda Penduduk',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nikController,
            label: 'NIK',
            hint: '16 digit NIK',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 16,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _birthPlaceController,
            label: 'Tempat Lahir',
            hint: 'Kota kelahiran',
            icon: Icons.location_city,
          ),
          const SizedBox(height: 16),
          _buildDateField(),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Jenis Kelamin',
            value: _gender,
            items: _genderOptions,
            icon: Icons.people,
            onChanged: (value) => setState(() => _gender = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressController,
            label: 'Alamat',
            hint: 'Alamat lengkap',
            icon: Icons.home,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _rtController,
                  label: 'RT',
                  hint: '000',
                  icon: Icons.location_on,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _rwController,
                  label: 'RW',
                  hint: '000',
                  icon: Icons.location_on,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _kelurahanController,
            label: 'Kelurahan',
            hint: 'Nama kelurahan',
            icon: Icons.apartment,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _kecamatanController,
            label: 'Kecamatan',
            hint: 'Nama kecamatan',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Agama',
            value: _religion,
            items: _religionOptions,
            icon: Icons.church,
            onChanged: (value) => setState(() => _religion = value),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Status Perkawinan',
            value: _maritalStatus,
            items: _maritalStatusOptions,
            icon: Icons.favorite,
            onChanged: (value) => setState(() => _maritalStatus = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: TextEditingController(text: _occupation),
            label: 'Pekerjaan',
            hint: 'Pekerjaan saat ini',
            icon: Icons.work,
            onChanged: (value) => _occupation = value,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: TextEditingController(text: _education),
            label: 'Pendidikan Terakhir (Opsional)',
            hint: 'Contoh: S1, SMA, dll',
            icon: Icons.school,
            onChanged: (value) => _education = value,
          ),
        ],
      ),
    );
  }

  Widget _buildKKPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Kartu Keluarga',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Informasi Keluarga',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _kkNumberController,
            label: 'Nomor Kartu Keluarga',
            hint: '16 digit nomor KK',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 16,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _headOfFamilyController,
            label: 'Nama Kepala Keluarga',
            hint: 'Nama lengkap kepala keluarga',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Hubungan dengan Kepala Keluarga',
            value: _relationToHead,
            items: _relationOptions,
            icon: Icons.people_alt,
            onChanged: (value) => setState(() => _relationToHead = value),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pastikan data yang Anda masukkan sesuai dengan KK yang terdaftar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    int? maxLines,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: AppColors.primary),
              border: InputBorder.none,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  _birthdate != null
                      ? DateFormat('dd MMMM yyyy', 'id_ID').format(_birthdate!)
                      : 'Pilih tanggal lahir',
                  style: TextStyle(
                    fontSize: 16,
                    color: _birthdate != null ? Colors.black : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: value,
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              hint: Text(
                'Pilih $label',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              icon: const SizedBox.shrink(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              menuMaxHeight: 300,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              selectedItemBuilder: (BuildContext context) {
                return items.map((String item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _previousPage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      _currentPage == 2 ? 'Selesai' : 'Lanjut',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
