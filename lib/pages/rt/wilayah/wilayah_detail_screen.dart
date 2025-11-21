import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/repositories/resident.dart' as residentRepo;
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/warga_detail_screen.dart';

class WilayahDetailScreen extends StatelessWidget {
  final Street street;

  const WilayahDetailScreen({required this.street, super.key});

  @override
  Widget build(BuildContext context) {
    // build residents list from dummy generator and attach to this street
    final generated = residentRepo.WargaRepository.generateDummy(count: 60);
    // create new Warga instances with addresses assigned to this street
    final residents = List<Warga>.generate(generated.length, (i) {
      final w = generated[i];
      final houseNo = (i % (street.totalHouses > 0 ? street.totalHouses : 6)) + 1;
      return Warga(
        id: w.id,
        name: w.name,
        nik: w.nik,
        kkNumber: w.kkNumber,
        address: '${street.name} No. $houseNo',
        isActive: w.isActive,
        ktpUrl: w.ktpUrl,
        kkUrl: w.kkUrl,
        createdAt: w.createdAt,
        rt: w.rt,
        rw: w.rw,
      );
    });

    final houseAddresses = residents
        .where((w) => w.address.startsWith(street.name))
        .map((w) => w.address)
        .toSet()
        .toList();

    final houseNumbers = houseAddresses.map((addr) {
      final parts = addr.split('No.');
      if (parts.length > 1) {
        final numPart = parts[1].trim();
        final parsed = int.tryParse(numPart);
        return parsed ?? 0;
      }
      return 0;
    }).where((n) => n > 0).toList()
      ..sort();

    final computedTotalHouses = houseNumbers.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          const Text('Detail Wilayah', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: const Icon(Icons.location_on, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(street.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${computedTotalHouses} Rumah', style: TextStyle(color: Colors.grey[700])),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          const Text('Daftar Rumah', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                itemCount: computedTotalHouses,
                itemBuilder: (c, i) {
                  final houseNo = houseNumbers[i];
                  final addr = '${street.name} No. $houseNo';
                  final houseResidents = residents.where((w) => w.address == addr).toList();
                  return ListTile(
                    hoverColor: AppColors.primary.withOpacity(0.06),
                    title: Text('No. $houseNo', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    subtitle: Text(houseResidents.isEmpty ? '— (tidak ada warga terdaftar)' : '${houseResidents.length} orang'),
                    trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                                  Text('Rumah No. $houseNo', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  if (houseResidents.isEmpty)
                                    const Text('Belum ada warga terdaftar di rumah ini.'),
                                  if (houseResidents.isNotEmpty)
                                    ...houseResidents.map((r) => ListTile(
                                          hoverColor: AppColors.primary.withOpacity(0.06),
                                          leading: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: const Icon(Icons.person, color: AppColors.primary, size: 20),
                                          ),
                                          title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                          subtitle: Text(r.nik),
                                          trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                                          onTap: () {
                                            Navigator.pop(dialogContext);
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => WargaDetailScreen(warga: r)));
                                          },
                                        )),
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
                                ]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
            ),
          )
        ]),
      ),
    );
  }
}
