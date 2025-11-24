import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/repositories/streets.dart' as repo;
import 'package:rukunin/pages/rt/wilayah/widgets/street_simple_card.dart';
import 'package:rukunin/pages/rt/wilayah/wilayah_add_screen.dart';
import 'package:rukunin/repositories/resident.dart' as residentRepo;
import 'package:rukunin/pages/rt/wilayah/wilayah_detail_screen.dart';

class WilayahRtScreen extends StatefulWidget {
  const WilayahRtScreen({super.key});

  @override
  State<WilayahRtScreen> createState() => _WilayahRtScreenState();
}

class _WilayahRtScreenState extends State<WilayahRtScreen> {
  List<Street> _items = [];
  List residents = [];

  @override
  void initState() {
    super.initState();
    _items = List<Street>.from(repo.streets);
    _prepareResidents();
  }

  void _prepareResidents() {
    // generate dummy residents and assign addresses across streets
    final generated = residentRepo.WargaRepository.generateDummy(count: 60);
    final List generatedAssigned = [];
    for (var i = 0; i < generated.length; i++) {
      final w = generated[i];
      final street = _items[i % _items.length];
      final houseNo = (i % (street.totalHouses > 0 ? street.totalHouses : 6)) + 1;
      // create new instance with address set to street
      generatedAssigned.add(
        // recreate Warga with updated address
        // use map to pass through fields
        {
          'id': w.id,
          'name': w.name,
          'nik': w.nik,
          'kkNumber': w.kkNumber,
          'address': '${street.name} No. $houseNo',
          'rt': w.rt,
          'rw': w.rw,
          'isActive': w.isActive,
          'ktpUrl': w.ktpUrl,
          'kkUrl': w.kkUrl,
          'createdAt': w.createdAt,
        },
      );
    }
    residents = generatedAssigned;
  }

  void _openAdd() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const WilayahAddScreen()));
    if (result != null && result is Map) {
      final Street newStreet = result['street'];
      setState(() {
        repo.addStreet(newStreet);
        _items.insert(0, newStreet);
        _prepareResidents();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wilayah "${newStreet.name}" berhasil disimpan'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  Future<void> _confirmDelete(int index) async {
    final street = _items[index];
    final hasResidents = residents.any((r) => (r['address'] as String).startsWith(street.name));
    if (hasResidents) {
      await showDialog<bool>(context: context, builder: (c) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 96, color: Colors.red.shade200),
                  const SizedBox(height: 12),
                  const Text('Tidak dapat menghapus', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('Terdapat warga/keluarga yang terdaftar pada jalan ini. Hapus data warga terlebih dahulu.', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Tutup', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
      return;
    }

    final ok = await showDialog<bool>(context: context, builder: (c) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 96, color: Colors.red.shade200),
                const SizedBox(height: 12),
                const Text('Hapus jalan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                Text('Yakin menghapus ${street.name}?', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(c, false),
                      child: Text('Batal', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
    if (ok == true) {
      setState(() {
        repo.removeStreetAt(index);
        _items.removeAt(index);
        _prepareResidents();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Wilayah berhasil dihapus'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Wilayah RT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Total wilayah: ${_items.length}', style: TextStyle(color: Colors.grey[700]))),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text('Belum ada jalan terdaftar', style: TextStyle(color: Colors.grey[700])))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (c, i) {
                        final s = _items[i];
                        return Dismissible(
                          key: ValueKey(s.name),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(color: Colors.red.withOpacity(0.95), borderRadius: BorderRadius.circular(12)),
                            child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.delete, color: Colors.white), SizedBox(width: 8), Text('Hapus', style: TextStyle(color: Colors.white))]),
                          ),
                          confirmDismiss: (_) async {
                            await _confirmDelete(i);
                            return false;
                          },
                          child: StreetSimpleCard(
                            streetName: s.name,
                            totalHouses: s.totalHouses,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WilayahDetailScreen(street: s))),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-street',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _openAdd,
      ),
    );
  }
}
