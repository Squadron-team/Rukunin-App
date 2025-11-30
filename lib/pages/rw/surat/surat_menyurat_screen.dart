import 'package:flutter/material.dart';
import 'models/surat_model.dart';
import 'widgets/surat_card.dart';
import 'widgets/filter_chips.dart';
import 'screens/tambah_surat_screen.dart';
import 'screens/detail_surat_screen.dart';

class SuratMenyuratScreen extends StatefulWidget {
  const SuratMenyuratScreen({super.key});

  @override
  State<SuratMenyuratScreen> createState() => _SuratMenyuratScreenState();
}

class _SuratMenyuratScreenState extends State<SuratMenyuratScreen> {
  String _selectedFilter = 'Semua';

  final List<Surat> _suratList = [
    Surat(
      jenis: 'Surat Keterangan Domisili',
      pemohon: 'Budi Santoso',
      tanggal: '15 Nov 2025',
      status: StatusSurat.menunggu,
      nomor: 'SKD/001/XI/2025',
    ),
    Surat(
      jenis: 'Surat Pengantar KTP',
      pemohon: 'Siti Aminah',
      tanggal: '14 Nov 2025',
      status: StatusSurat.disetujui,
      nomor: 'SP/002/XI/2025',
    ),
    Surat(
      jenis: 'Surat Keterangan Tidak Mampu',
      pemohon: 'Ahmad Hidayat',
      tanggal: '13 Nov 2025',
      status: StatusSurat.ditolak,
      nomor: 'SKTM/003/XI/2025',
    ),
    Surat(
      jenis: 'Surat Keterangan Usaha',
      pemohon: 'Dewi Lestari',
      tanggal: '12 Nov 2025',
      status: StatusSurat.menunggu,
      nomor: 'SKU/004/XI/2025',
    ),
    Surat(
      jenis: 'Surat Pengantar SKCK',
      pemohon: 'Rudi Hartono',
      tanggal: '11 Nov 2025',
      status: StatusSurat.disetujui,
      nomor: 'SP/005/XI/2025',
    ),
  ];

  // FILTER LIST
  List<Surat> get _filteredSuratList {
    switch (_selectedFilter) {
      case 'Menunggu':
        return _suratList.where((s) => s.status == StatusSurat.menunggu).toList();
      case 'Disetujui':
        return _suratList.where((s) => s.status == StatusSurat.disetujui).toList();
      case 'Ditolak':
        return _suratList.where((s) => s.status == StatusSurat.ditolak).toList();
      default:
        return _suratList;
    }
  }

  // STATISTIK
  int get _total => _suratList.length;
  int get _menunggu => _suratList.where((s) => s.status == StatusSurat.menunggu).length;
  int get _disetujui => _suratList.where((s) => s.status == StatusSurat.disetujui).length;
  int get _ditolak => _suratList.where((s) => s.status == StatusSurat.ditolak).length;

  // REFRESH
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surat Menyurat',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),

      backgroundColor: Colors.grey[50],

      body: Column(
        children: [
          // --- BAGIAN HEADER STATISTIK ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Total', _total.toString(), Icons.mail_outline, Colors.white),
                _buildStatCard('Menunggu', _menunggu.toString(), Icons.pending, Colors.orange),
                _buildStatCard('Disetujui', _disetujui.toString(), Icons.check_circle, Colors.green),
                _buildStatCard('Ditolak', _ditolak.toString(), Icons.cancel, Colors.red),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // FILTER
          FilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),

          const SizedBox(height: 12),

          // LIST SURAT
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _filteredSuratList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredSuratList.length,
                      itemBuilder: (context, index) {
                        final surat = _filteredSuratList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SuratCard(
                            surat: surat,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailSuratScreen(surat: surat),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahSuratScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Buat Surat'),
      ),
    );
  }

  // --- WIDGET EMPTY STATE ---
  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'Belum ada surat $_selectedFilter',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tarik ke bawah untuk refresh',
                      style: TextStyle(color: Colors.grey[500]),
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

  // --- WIDGET STATISTIK ---
  Widget _buildStatCard(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
