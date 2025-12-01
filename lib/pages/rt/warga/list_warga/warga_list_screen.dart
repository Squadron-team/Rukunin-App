import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/warga/widgets/warga_card.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_detail_screen.dart';
import 'package:rukunin/pages/rt/warga/list_warga/warga_add_screen.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/theme/app_colors.dart';
// toolbar uses internal widgets; imports moved to toolbar widget file
import 'package:rukunin/pages/rt/warga/widgets/warga_toolbar.dart';
import 'package:rukunin/pages/rt/warga/widgets/delete_background.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/confirm_dialogs.dart';

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
  bool _showFilter = false;

  @override
  void initState() {
    super.initState();
    _all = WargaRepository.generateDummy(count: 60);
    _visible = List.from(_all);
  }

  void _applyFilters() {
    setState(() {
      _visible = _all.where((w) {
        final matchesQuery =
            query.isEmpty ||
            w.name.toLowerCase().contains(query.toLowerCase()) ||
            w.nik.contains(query);
        final matchesFilter =
            filter == 'Semua' ||
            (filter == 'Aktif' && w.isActive) ||
            (filter == 'Non-aktif' && !w.isActive);
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Data Warga',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  WargaToolbar(
                    onSearchChanged: (v) {
                      query = v;
                      _applyFilters();
                    },
                    onDownload: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Data warga berhasil diunduh'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    showFilter: _showFilter || filter != 'Semua',
                    onToggleFilter: () =>
                        setState(() => _showFilter = !_showFilter),
                  ),
                  const SizedBox(height: 12),
                  if (_showFilter)
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
                  if (_visible.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Data warga RT ${_visible.first.rt} / RW ${_visible.first.rw}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Text(
                            'Total: ${_visible.length}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _visible.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada data',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: _visible.length,
                            itemBuilder: (context, index) {
                              final warga = _visible[index];
                              return Dismissible(
                                key: ValueKey(warga.id),
                                direction: DismissDirection.endToStart,
                                background: const DeleteBackground(),
                                confirmDismiss: (dir) async {
                                  final ok = await showConfirmDeleteDialog(
                                    context,
                                    warga.name,
                                  );
                                  if (ok ?? false) {
                                    setState(() {
                                      _all.removeWhere((e) => e.id == warga.id);
                                      _applyFilters();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Warga berhasil dihapus',
                                        ),
                                        backgroundColor: AppColors.primary,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return ok ?? false;
                                },
                                child: WargaCard(
                                  warga: warga,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            WargaDetailScreen(warga: warga),
                                      ),
                                    );
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
                      final newWarga = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WargaAddScreen(),
                        ),
                      );
                      if (newWarga != null && newWarga is Warga) {
                        setState(() {
                          _all.insert(0, newWarga);
                          _applyFilters();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Warga baru berhasil ditambahkan',
                            ),
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
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
