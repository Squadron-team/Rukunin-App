import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_detail_screen.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_preview_dialog.dart';

class DataKeluargaScreen extends StatefulWidget {
  final List<Warga>? members;
  final String? kkNumber;
  final String? headOfFamily;

  const DataKeluargaScreen({
    super.key,
    this.members,
    this.kkNumber,
    this.headOfFamily,
  });

  /// Helper constructor to open the screen with an existing family
  const DataKeluargaScreen.fromFamily({
    required List<Warga> members,
    required String kkNumber,
    super.key,
    String? head,
  }) : members = members,
       kkNumber = kkNumber,
       headOfFamily = head;

  @override
  State<DataKeluargaScreen> createState() => _DataKeluargaScreenState();
}

class _DataKeluargaScreenState extends State<DataKeluargaScreen> {
  late List<Warga> _members;
  late String _kkNumber;
  late String _headOfFamily;

  @override
  void initState() {
    super.initState();
    if (widget.members != null) {
      _members = widget.members!;
      _kkNumber =
          widget.kkNumber ??
          (widget.members!.isNotEmpty ? widget.members!.first.kkNumber : 'KK-');
      _headOfFamily =
          widget.headOfFamily ??
          (widget.members!.isNotEmpty
              ? widget.members!.first.name
              : 'Kepala Keluarga');
    } else {
      _generateDummyFamily();
    }
  }

  void _generateDummyFamily() {
    final base = WargaRepository.generateDummy(count: 8);
    _headOfFamily = base.first.name;
    _kkNumber =
        'KK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    _members = List.generate(4, (i) {
      final b = base[i % base.length];
      return Warga(
        id: b.id,
        name: b.name,
        nik: b.nik,
        kkNumber: _kkNumber,
        address: b.address,
        isActive: b.isActive,
        ktpUrl: b.ktpUrl,
        kkUrl: b.kkUrl,
        createdAt: b.createdAt,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Data Keluarga',
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildKKSummaryCard(),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Anggota Keluarga',
                subtitle: '${_members.length} orang terdaftar',
              ),
              const SizedBox(height: 12),
              ..._members.map((m) => _buildFamilyMemberCard(m)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKKSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kartu Keluarga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Informasi Lengkap Keluarga',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildInfoRow('No. Kartu Keluarga', _kkNumber, isHighlight: true),
          const SizedBox(height: 12),
          _buildInfoRow('Kepala Keluarga', _headOfFamily),
          const SizedBox(height: 12),
          _buildInfoRow('Jumlah Anggota', '${_members.length} orang'),
          const SizedBox(height: 12),
          // KK preview (open first member's KK if available)
          if (_members.isNotEmpty)
            Row(
              children: [
                _buildKkThumbnail(),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.visibility, color: Colors.white),
                  label: const Text(
                    'Lihat KK',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _members.first.kkUrl.isNotEmpty
                      ? () => showDocPreview(
                          context,
                          type: 'KK',
                          name: _headOfFamily,
                          number: _kkNumber,
                          url: _members.first.kkUrl,
                        )
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(Warga member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WargaDetailScreen(warga: member)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'NIK: ${member.nik}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isHighlight ? AppColors.primary : Colors.black,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKkThumbnail() {
    final url = _members.isNotEmpty ? _members.first.kkUrl : '';
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          url,
          width: 84,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            width: 84,
            height: 56,
            color: Colors.grey[100],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      );
    }
    return Container(
      width: 84,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
