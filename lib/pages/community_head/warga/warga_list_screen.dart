import 'package:flutter/material.dart';
import 'package:rukunin/pages/community_head/community_head_layout.dart';
import 'package:rukunin/pages/community_head/warga/warga_card.dart';
import 'package:rukunin/pages/community_head/warga/warga_detail_screen.dart';
import 'package:rukunin/pages/community_head/warga/warga_add_screen.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaListScreen extends StatefulWidget {
  const WargaListScreen({super.key});

  @override
  State<WargaListScreen> createState() => _WargaListScreenState();
}

class _WargaListScreenState extends State<WargaListScreen> {
  late List<Warga> _all;
  late List<Warga> _visible;
  String query = '';
  String filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _all = WargaRepository.generateDummy(count: 60);
    _visible = List.from(_all);
  }

  void _applyFilters() {
    setState(() {
      _visible = _all.where((w) {
        final matchesQuery = query.isEmpty || w.name.toLowerCase().contains(query.toLowerCase()) || w.nik.contains(query);
        final matchesFilter = filter == 'Semua' || (filter == 'Aktif' && w.isActive) || (filter == 'Non-aktif' && !w.isActive);
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _all.length;
    final aktif = _all.where((w) => w.isActive).length;
    final nonaktif = total - aktif;

    return CommunityHeadLayout(
      title: 'Warga',
      currentIndex: 1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau NIK',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      onChanged: (v) {
                        query = v;
                        _applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Data warga berhasil diunduh'),
                        backgroundColor: Colors.yellow[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ));
                    },
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Unduh'),
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildFilterChip('Semua')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFilterChip('Aktif')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFilterChip('Non-aktif')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total warga: $total', style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('Aktif $aktif  •  Non-aktif $nonaktif', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _visible.isEmpty
                    ? Center(child: Text('Tidak ada data', style: TextStyle(color: Colors.grey[600])))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120),
                        itemCount: _visible.length,
                        itemBuilder: (context, index) {
                          final warga = _visible[index];
                          return Dismissible(
                            key: ValueKey(warga.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.95), borderRadius: BorderRadius.circular(12)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.delete, color: Colors.white), SizedBox(width: 8), Text('Hapus', style: TextStyle(color: Colors.white))]),
                            ),
                            confirmDismiss: (dir) async {
                              final ok = await showDialog<bool>(context: context, builder: (c) {
                                return AlertDialog(
                                  title: const Text('Hapus warga'),
                                  content: Text('Yakin menghapus ${warga.name}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
                                    ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
                                  ],
                                );
                              });
                              if (ok ?? false) {
                                setState(() {
                                  _all.removeWhere((e) => e.id == warga.id);
                                  _applyFilters();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Warga berhasil dihapus'),
                                  backgroundColor: Colors.yellow[700],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ));
                              }
                              return ok ?? false;
                            },
                            child: WargaCard(
                              warga: warga,
                              onTap: () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (_) => WargaDetailScreen(warga: warga)));
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

              // Floating button 
              Positioned(
                right: 4,
                bottom: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'add-warga',
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      final newWarga = await Navigator.push(context, MaterialPageRoute(builder: (_) => const WargaAddScreen()));
                      if (newWarga != null && newWarga is Warga) {
                        setState(() {
                          _all.insert(0, newWarga);
                          _applyFilters();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Warga baru berhasil ditambahkan'),
                          backgroundColor: Colors.yellow[700],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value) {
    final selected = filter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          filter = value;
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? AppColors.primary : Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}
