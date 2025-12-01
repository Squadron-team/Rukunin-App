import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/repositories/streets.dart' as repo;
import 'package:rukunin/pages/rt/wilayah/wilayah_add_screen.dart';
import 'package:rukunin/pages/rt/wilayah/wilayah_detail_screen.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/resident_helper.dart' as rh;
import 'package:rukunin/pages/rt/wilayah/widgets/street_list.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/confirm_dialogs.dart';

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
    residents = rh.generateAssignedResidents(_items, count: 60);
  }

  void _openAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WilayahAddScreen()),
    );
    if (result != null && result is Map) {
      final Street newStreet = result['street'];
      setState(() {
        repo.addStreet(newStreet);
        _items.insert(0, newStreet);
        _prepareResidents();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wilayah "${newStreet.name}" berhasil disimpan'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<bool> _handleDelete(int index) async {
    final street = _items[index];
    final hasResidents = residents.any(
      (r) => (r['address'] as String).startsWith(street.name),
    );
    if (hasResidents) {
      await showCannotDeleteDialog(context);
      return false;
    }

    final ok = await showConfirmDeleteDialog(context, street.name);
    if (ok == true) {
      setState(() {
        repo.removeStreetAt(index);
        _items.removeAt(index);
        _prepareResidents();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wilayah berhasil dihapus'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Wilayah RT',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
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
                Expanded(
                  child: Text(
                    'Total wilayah: ${_items.length}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreetList(
                items: _items,
                residents: residents,
                onTap: (s) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WilayahDetailScreen(street: s),
                  ),
                ),
                onDelete: (idx) => _handleDelete(idx),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-street',
        backgroundColor: AppColors.primary,
        onPressed: _openAdd,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
