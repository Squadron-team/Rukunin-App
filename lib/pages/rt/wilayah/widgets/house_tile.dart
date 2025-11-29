import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/models/house.dart';
import 'package:rukunin/pages/rt/warga/list_keluarga/data_keluarga_screen.dart';

class HouseTile extends StatelessWidget {
  final String streetName;
  final int houseNo;
  final List<Warga> residents; // residents for this house
  final House addedHouse; // may be an empty placeholder

  const HouseTile({
    required this.streetName,
    required this.houseNo,
    required this.residents,
    required this.addedHouse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final houseStatus = (residents.isEmpty && (addedHouse.id.isEmpty || !addedHouse.isOccupied))
        ? 'Kosong'
        : 'Berpenghuni';
    final totalMembers = residents.length;

    return ListTile(
      hoverColor: AppColors.primary.withOpacity(0.06),
      title: Text(
        'No. $houseNo',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        houseStatus == 'Kosong' ? 'Kosong' : 'Berpenghuni — $totalMembers warga',
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.primary,
      ),
      onTap: () => _showFamiliesDialog(context),
    );
  }

  void _showFamiliesDialog(BuildContext context) {
    // group residents by KK
    final Map<String, List<Warga>> familiesByKk = {};
    for (final r in residents) {
      if (r.kkNumber.isEmpty) continue;
      familiesByKk.putIfAbsent(r.kkNumber, () => []).add(r);
    }
    final families = familiesByKk.entries.map((e) {
      final members = e.value;
      final head = members.first;
      final digits = e.key.replaceAll(RegExp(r'[^0-9]'), '');
      int lastDigit = 0;
      if (digits.isNotEmpty) {
        lastDigit = int.tryParse(digits[digits.length - 1]) ?? 0;
      }
      final status = (lastDigit % 2 == 0) ? 'tetap' : 'kontrak';
      return {
        'kk': e.key,
        'head': head,
        'members': members,
        'status': status,
      };
    }).toList();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final maxHeight = MediaQuery.of(dialogContext).size.height * 0.75;
        final isSmall = families.length <= 1;
        final dialogWidth = isSmall ? 420.0 : 520.0;
        final baseHeight = isSmall ? 160.0 : 140.0;
        const perFamily = 64.0;
        final desiredHeight = baseHeight + (families.length * perFamily);
        final dialogMaxHeight = desiredHeight.clamp(140.0, maxHeight);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: dialogMaxHeight),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rumah No. $houseNo',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (families.isEmpty) const Text('Belum ada keluarga terdaftar di rumah ini.'),
                            if (families.isNotEmpty)
                              ...families.map((f) {
                                final Warga head = f['head'] as Warga;
                                final kk = f['kk'] as String;
                                final members = List<Warga>.from(f['members'] as List);
                                final status = f['status'] as String;
                                final statusColor = status == 'tetap' ? Colors.green : Colors.orange;
                                return ListTile(
                                  hoverColor: AppColors.primary.withOpacity(0.06),
                                  leading: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.family_restroom, color: AppColors.primary, size: 20),
                                  ),
                                  title: Text('Keluarga ${head.name}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                  subtitle: Text('KK: $kk • ${members.length} anggota'),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(status == 'tetap' ? 'Tetap' : 'Kontrak', style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
                                  ),
                                  onTap: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DataKeluargaScreen.fromFamily(
                                          members: members,
                                          kkNumber: kk,
                                          head: head.name,
                                          status: status,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Tutup', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
