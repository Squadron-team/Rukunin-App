import 'package:flutter/material.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_detail_screen.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_preview_dialog.dart';
import 'package:rukunin/pages/rt/warga/widgets/family_member_card.dart';
import 'package:rukunin/pages/rt/warga/widgets/kk_summary_card.dart';

class DataKeluargaScreen extends StatefulWidget {
  final List<Warga>? members;
  final String? kkNumber;
  final String? headOfFamily;
  final String? familyStatus; // 'tetap' or 'kontrak'

  const DataKeluargaScreen({
    super.key,
    this.members,
    this.kkNumber,
    this.headOfFamily,
    this.familyStatus,
  });

  /// Helper constructor to open the screen with an existing family
  const DataKeluargaScreen.fromFamily({
    required List<Warga> members,
    required String kkNumber,
    super.key,
    String? head,
    String? status,
  }) : members = members,
       kkNumber = kkNumber,
       headOfFamily = head,
       familyStatus = status;

  @override
  State<DataKeluargaScreen> createState() => _DataKeluargaScreenState();
}

class _DataKeluargaScreenState extends State<DataKeluargaScreen> {
  late List<Warga> _members;
  late String _kkNumber;
  late String _headOfFamily;
  late String _familyStatus; // 'tetap' or 'kontrak'

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
      _familyStatus = widget.familyStatus ?? 'tetap';
    } else {
      _generateDummyFamily();
    }
  }

  void _generateDummyFamily() {
    final base = WargaRepository.generateDummy(count: 8);
    _headOfFamily = base.first.name;
    _kkNumber =
        'KK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _familyStatus = 'tetap';

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
              KkSummaryCard(
                kkNumber: _kkNumber,
                headOfFamily: _headOfFamily,
                members: _members,
                familyStatus: _familyStatus,
                onStatusChanged: (v) => setState(() => _familyStatus = v),
                onViewKk: _members.isNotEmpty && _members.first.kkUrl.isNotEmpty
                    ? () => showDocPreview(
                        context,
                        type: 'KK',
                        name: _headOfFamily,
                        number: _kkNumber,
                        url: _members.first.kkUrl,
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Anggota Keluarga',
                subtitle: '${_members.length} orang terdaftar',
              ),
              const SizedBox(height: 12),
              ..._members.map(
                (m) => FamilyMemberCard(
                  member: m,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WargaDetailScreen(warga: m),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
}
