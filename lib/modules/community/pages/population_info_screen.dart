import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class PopulationInfoScreen extends StatefulWidget {
  const PopulationInfoScreen({super.key});

  @override
  State<PopulationInfoScreen> createState() => _PopulationInfoScreenState();
}

class _PopulationInfoScreenState extends State<PopulationInfoScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _familyMembers = [];

  @override
  void initState() {
    super.initState();
    _loadPopulationData();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '-';
    if (timestamp is String) return timestamp;
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return DateFormat('dd MMMM yyyy').format(date);
    }
    return timestamp.toString();
  }

  String _getStringValue(dynamic value) {
    if (value == null) return '-';
    if (value is String) return value;
    if (value is Timestamp) return _formatTimestamp(value);
    return value.toString();
  }

  Future<void> _loadPopulationData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Load user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        setState(() {
          _userData = data;
        });

        // Load family members if KK number exists
        if (data?['kkNumber'] != null) {
          final familyQuery = await _firestore
              .collection('users')
              .where('kkNumber', isEqualTo: data!['kkNumber'])
              .get();

          setState(() {
            _familyMembers = familyQuery.docs
                .map((doc) => {...doc.data(), 'id': doc.id})
                .where((member) => member['id'] != user.uid)
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading population data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Informasi Kependudukan'),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : RefreshIndicator(
              onRefresh: _loadPopulationData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Personal Info Section
                  _buildSectionHeader('Data Pribadi'),
                  const SizedBox(height: 12),
                  _buildPersonalInfoCard(),

                  const SizedBox(height: 24),

                  // KK Info Section
                  _buildSectionHeader('Kartu Keluarga (KK)'),
                  const SizedBox(height: 12),
                  _buildKKInfoCard(),

                  if (_familyMembers.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionHeader('Anggota Keluarga'),
                    const SizedBox(height: 12),
                    ..._familyMembers.map(
                      (member) => _buildFamilyMemberCard(member),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Request Correction Button
                  _buildRequestCorrectionCard(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KTP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Kartu Tanda Penduduk',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow('NIK', _getStringValue(_userData?['nik'])),
          _buildInfoRow('Nama Lengkap', _getStringValue(_userData?['name'])),
          _buildInfoRow(
            'Tempat Lahir',
            _getStringValue(_userData?['birthPlace']),
          ),
          _buildInfoRow(
            'Tanggal Lahir',
            _formatTimestamp(_userData?['birthdate']),
          ),
          _buildInfoRow('Jenis Kelamin', _getStringValue(_userData?['gender'])),
          _buildInfoRow('Alamat', _getStringValue(_userData?['address'])),
          _buildInfoRow(
            'RT/RW',
            '${_getStringValue(_userData?['rt'])} / ${_getStringValue(_userData?['rw'])}',
          ),
          _buildInfoRow('Kelurahan', _getStringValue(_userData?['kelurahan'])),
          _buildInfoRow('Kecamatan', _getStringValue(_userData?['kecamatan'])),
          _buildInfoRow('Agama', _getStringValue(_userData?['religion'])),
          _buildInfoRow(
            'Status Perkawinan',
            _getStringValue(_userData?['maritalStatus']),
          ),
          _buildInfoRow('Pekerjaan', _getStringValue(_userData?['occupation'])),
        ],
      ),
    );
  }

  Widget _buildKKInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kartu Keluarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Informasi Kepala Keluarga',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow('No. KK', _getStringValue(_userData?['kkNumber'])),
          _buildInfoRow(
            'Kepala Keluarga',
            _getStringValue(_userData?['headOfFamily'] ?? _userData?['name']),
          ),
          _buildInfoRow(
            'Jumlah Anggota',
            '${(_familyMembers.length + 1).toString()} orang',
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(Map<String, dynamic> member) {
    return Container(
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.grey[600], size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStringValue(member['name']),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStringValue(member['relationToHead']),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                if (member['nik'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'NIK: ${_getStringValue(member['nik'])}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCorrectionCard() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to correction request form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Fitur pengajuan koreksi data akan segera tersedia',
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_document,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ajukan Koreksi Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ada data yang tidak sesuai? Ajukan koreksi',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
