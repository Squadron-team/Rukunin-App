import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/models/mutasi.dart';
import 'package:rukunin/pages/rt/mutasi/mutasi_add_screen.dart';

class MutasiListScreen extends StatefulWidget {
  const MutasiListScreen({super.key});

  @override
  State<MutasiListScreen> createState() => _MutasiListScreenState();
}

class _MutasiListScreenState extends State<MutasiListScreen> {
  final List<Mutasi> _items = [];

  @override
  void initState() {
    super.initState();
    _items.addAll(_generateDummy());
  }

  List<Mutasi> _generateDummy() {
    final now = DateTime.now();
    return List.generate(12, (i) {
      final jenis = (i % 3 == 0) ? 'Keluar' : 'Pindah Rumah';
      final keluargaName = 'Keluarga Warga ${i + 1}';
      final rumahLama = 'Jalan Mawar No. ${10 + i}';
      final rumahBaru = jenis == 'Pindah Rumah'
          ? 'Jalan Melati No. ${20 + i}'
          : null;
      return Mutasi(
        id: 'mutasi_${i + 1}',
        jenis: jenis,
        keluargaId: 'fam_${i + 1}',
        keluargaName: keluargaName,
        rumahLama: rumahLama,
        rumahBaru: rumahBaru,
        alasan: 'Alasan contoh untuk mutasi $i',
        tanggalMutasi: now.subtract(Duration(days: i * 2)),
        createdAt: now.subtract(Duration(days: i * 2)),
      );
    });
  }

  List<Mutasi> _filtered(int tabIndex) {
    if (tabIndex == 0) return _items;
    final type = tabIndex == 1 ? 'Pindah Rumah' : 'Keluar';
    return _items.where((m) => m.jenis == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Catat Mutasi',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[700],
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Pindah Rumah'),
              Tab(text: 'Keluar'),
            ],
          ),
          foregroundColor: Colors.black,
        ),
        body: TabBarView(
          children: List.generate(3, (tabIndex) {
            final list = _filtered(tabIndex);
            if (list.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada catatan mutasi',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16).copyWith(bottom: 120),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final m = list[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        m.jenis == 'Keluar'
                            ? Icons.exit_to_app
                            : Icons.home_work,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      m.keluargaName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(m.jenis),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal: ${DateFormat('yyyy-MM-dd').format(m.tanggalMutasi)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.jenis == 'Keluar'
                              ? 'Rumah lama: ${m.rumahLama}'
                              : 'Dari: ${m.rumahLama} → Ke: ${m.rumahBaru ?? '-'}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // no trailing action - list is read-only
                  ),
                );
              },
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'add-mutasi',
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            final result = await Navigator.push<Mutasi>(
              context,
              MaterialPageRoute(builder: (_) => const MutasiAddScreen()),
            );
            if (result != null) {
              setState(() => _items.insert(0, result));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Mutasi berhasil dicatat'),
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
    );
  }
}
