import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import '../../../models/rt_letter.dart';
import 'form.dart';

class CreateRtToRwLetterScreen extends StatefulWidget {
  const CreateRtToRwLetterScreen({super.key});

  @override
  State<CreateRtToRwLetterScreen> createState() => _CreateRtToRwLetterScreenState();
}

class _CreateRtToRwLetterScreenState extends State<CreateRtToRwLetterScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Buat Surat untuk RW',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: _buildTabBar(),
        ),
        body: const TabBarView(children: [_TypesTab(), _HistoryTab()]),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: Colors.white,
        child: TabBar(
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Jenis Surat'), Tab(text: 'Riwayat')],
        ),
      ),
    );
  }
}

class _TypesTab extends StatelessWidget {
  const _TypesTab();

  @override
  Widget build(BuildContext context) {
    final types = [
      {
        'key': 'pengesahan',
        'title': 'Permohonan Pengesahan Dokumen',
        'desc': 'Minta RW menandatangani atau mengesahkan dokumen RT',
        'color': AppColors.primary,
        'icon': Icons.document_scanner,
      },
      {
        'key': 'bantuan',
        'title': 'Permohonan Bantuan / Fasilitas',
        'desc': 'Surat pengantar untuk warga yang membutuhkan bantuan',
        'color': Colors.indigo,
        'icon': Icons.volunteer_activism,
      },
      {
        'key': 'kegiatan',
        'title': 'Pemberitahuan Kegiatan',
        'desc': 'Memberi tahu RW tentang kegiatan RT',
        'color': Colors.green,
        'icon': Icons.event,
      },
      {
        'key': 'rekomendasi',
        'title': 'Pengantar / Rekomendasi RW',
        'desc': 'Surat pengantar atau rekomendasi dari RT ke RW',
        'color': Colors.teal,
        'icon': Icons.thumb_up,
      },
      {
        'key': 'laporan',
        'title': 'Laporan Kejadian / Keamanan',
        'desc': 'Laporan insiden atau keamanan untuk RW',
        'color': Colors.red,
        'icon': Icons.report,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: types.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final t = types[index];
        return _buildTypeCard(
          context,
          icon: t['icon'] as IconData,
          title: t['title'] as String,
          description: t['desc'] as String,
          color: t['color'] as Color,
          onTap: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RtToRwLetterFormScreen(
                  typeKey: t['key'] as String,
                  typeTitle: t['title'] as String,
                  color: t['color'] as Color,
                  icon: t['icon'] as IconData,
                ),
              ),
            );
            if (res == true) {
              // after successful submit, refresh by popping and returning
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Surat berhasil dibuat'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildTypeCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ]),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab();

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  List<dynamic> _items = [];

  void _load() {
    _items = RtLetterRepository.all();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
                child: const Center(child: Icon(Icons.description_outlined, size: 40, color: AppColors.primary)),
              ),
              const SizedBox(height: 12),
              const Text('Belum ada riwayat', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              const SizedBox(height: 8),
              Text('Belum ada surat yang pernah dibuat', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final it = _items[index] as RtLetter;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(it.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)), child: Text(it.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),]),
            const SizedBox(height: 8),
            Text(it.purpose, style: TextStyle(fontSize: 14, color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text('${it.createdAt.day}/${it.createdAt.month}/${it.createdAt.year}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ]),
        );
      },
    );
  }
}
