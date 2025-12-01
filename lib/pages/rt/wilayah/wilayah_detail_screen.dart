import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/repositories/resident.dart' as residentRepo;
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/models/house.dart';
import 'package:rukunin/pages/rt/wilayah/add_house_screen.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/house_tile.dart';

class WilayahDetailScreen extends StatefulWidget {
  final Street street;

  const WilayahDetailScreen({required this.street, super.key});

  @override
  State<WilayahDetailScreen> createState() => _WilayahDetailScreenState();
}

class _WilayahDetailScreenState extends State<WilayahDetailScreen> {
  final List<House> _addedHouses = [];

  @override
  Widget build(BuildContext context) {
    final street = widget.street;
    // build residents list from dummy generator and attach to this street
    final generated = residentRepo.WargaRepository.generateDummy(count: 60);
    // create new Warga instances with addresses assigned to this street
    final residents = List<Warga>.generate(generated.length, (i) {
      final w = generated[i];
      final houseNo =
          (i % (street.totalHouses > 0 ? street.totalHouses : 6)) + 1;
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

    final houseNumbers = houseAddresses
        .map((addr) {
          final parts = addr.split('No.');
          if (parts.length > 1) {
            final numPart = parts[1].trim();
            final parsed = int.tryParse(numPart);
            return parsed ?? 0;
          }
          return 0;
        })
        .where((n) => n > 0)
        .toList();

    // include user-added houses for this street
    final addedNums = _addedHouses
        .where((h) => h.streetName == street.name)
        .map((h) => h.houseNo)
        .toList();
    final combinedSet = <int>{}
      ..addAll(houseNumbers)
      ..addAll(addedNums);
    final combinedNumbers = combinedSet.toList()..sort();

    final computedTotalHouses = combinedNumbers.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Detail Wilayah',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        street.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$computedTotalHouses Rumah',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Daftar Rumah',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: computedTotalHouses,
                itemBuilder: (c, i) {
                  final houseNo = combinedNumbers[i];
                  final addr = '${street.name} No. $houseNo';
                  final houseResidents = residents
                      .where((w) => w.address == addr)
                      .toList();

                  // group residents by KK to form families
                  final Map<String, List<Warga>> familiesByKk = {};
                  for (final r in houseResidents) {
                    if (r.kkNumber.isEmpty) continue;
                    familiesByKk.putIfAbsent(r.kkNumber, () => []).add(r);
                  }

                  // build family groups from residents

                  // if this house was added by user, check occupancy flag
                  final addedHouse = _addedHouses.firstWhere(
                    (h) => h.streetName == street.name && h.houseNo == houseNo,
                    orElse: () => House(id: '', streetName: '', houseNo: 0),
                  );

                  return HouseTile(
                    streetName: street.name,
                    houseNo: houseNo,
                    residents: houseResidents,
                    addedHouse: addedHouse,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-house',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddHouseScreen(
                street: street,
                existingHouseNumbers: combinedNumbers.toSet(),
              ),
            ),
          );
          if (result != null && result is House) {
            setState(() {
              _addedHouses.add(result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rumah No. ${result.houseNo} ditambahkan'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
