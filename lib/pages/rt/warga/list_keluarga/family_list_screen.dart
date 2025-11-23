import 'package:flutter/material.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/warga/list_keluarga/data_keluarga_screen.dart';
import 'package:rukunin/pages/rt/warga/widgets/search_bar.dart';

class FamilyListScreen extends StatefulWidget {
  const FamilyListScreen({super.key});

  @override
  State<FamilyListScreen> createState() => _FamilyListScreenState();
}

class _FamilyListScreenState extends State<FamilyListScreen> {
  late List<Warga> _all;
  late List<Map<String, dynamic>> _families; // all families {kk, head, members}
  late List<Map<String, dynamic>> _displayedFamilies; // filtered list
  String _query = '';

  @override
  void initState() {
    super.initState();
    _all = WargaRepository.generateDummy(count: 60);
    _buildFamilies();
    _displayedFamilies = List<Map<String, dynamic>>.from(_families);
  }

  void _buildFamilies() {
    final Map<String, List<Warga>> groups = {};
    for (final w in _all) {
      if (w.kkNumber.isEmpty) continue;
      groups.putIfAbsent(w.kkNumber, () => []).add(w);
    }
    _families = groups.entries.map((e) {
      final members = e.value;
      final head = members.first;
      return {'kk': e.key, 'head': head, 'members': members};
    }).toList()
      ..sort((a, b) => (a['head'] as Warga).name.compareTo((b['head'] as Warga).name));
  }

  void _applyFilter(String q) {
    _query = q.trim().toLowerCase();
    if (_query.isEmpty) {
      setState(() {
        _displayedFamilies = List<Map<String, dynamic>>.from(_families);
      });
      return;
    }

    final filtered = _families.where((fam) {
      final head = (fam['head'] as Warga).name.toLowerCase();
      final kk = (fam['kk'] as String).toLowerCase();
      return head.contains(_query) || kk.contains(_query);
    }).toList();

    setState(() {
      _displayedFamilies = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Daftar Keluarga', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _displayedFamilies.isEmpty
              ? Center(child: Text(_query.isEmpty ? 'Belum ada keluarga' : 'Tidak ada hasil', style: TextStyle(color: Colors.grey[700])))
              : Column(
                  children: [
                    WargaSearchBar(
                      hint: 'Cari keluarga atau KK',
                      onChanged: _applyFilter,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _displayedFamilies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final fam = _displayedFamilies[index];
                    final Warga head = fam['head'] as Warga;
                          final List<Warga> members = List<Warga>.from(fam['members'] as List);
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DataKeluargaScreen.fromFamily(
                              members: members,
                              kkNumber: fam['kk'] as String,
                              head: head.name,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                          child: Row(children: [
                            CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.family_restroom, color: AppColors.primary)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Keluarga ${head.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text('KK: ${fam['kk']}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                              ]),
                            ),
                            Text('${members.length} anggota', style: TextStyle(color: Colors.grey[700])),
                          ]),
                        ),
                      ),
                    );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
