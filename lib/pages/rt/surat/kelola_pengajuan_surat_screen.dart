import 'package:flutter/material.dart';
import 'package:rukunin/repositories/document_requests_repository.dart';
import 'package:rukunin/pages/rt/surat/models/document_request.dart';
import 'package:rukunin/pages/rt/surat/widgets/document_request_card.dart';
import 'package:rukunin/pages/rt/surat/widgets/request_detail_page.dart';
import 'package:rukunin/pages/rt/surat/category_requests_screen.dart';
import 'package:rukunin/style/app_colors.dart';

class KelolaPengajuanSuratScreen extends StatefulWidget {
  const KelolaPengajuanSuratScreen({Key? key}) : super(key: key);

  @override
  State<KelolaPengajuanSuratScreen> createState() =>
      _KelolaPengajuanSuratScreenState();
}

class _KelolaPengajuanSuratScreenState
    extends State<KelolaPengajuanSuratScreen> {
  final DocumentRequestsRepository _repo = DocumentRequestsRepository();
  List<DocumentRequest> _all = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _repo.getRequests();
    setState(() => _all = items);
  }

  Future<void> _updateStatus(DocumentRequest item, String status) async {
    await _repo.updateStatus(item.id, status);
    await _load();
  }

  // filters removed: only categories + recent items are shown

  Widget _buildCategories() {
    final categories = [
      {
        'key': 'domicile',
        'label': 'Domisili',
        'icon': Icons.home_outlined,
        'color': Colors.blue,
      },
      {
        'key': 'sktm',
        'label': 'Tidak Mampu',
        'icon': Icons.people_outline,
        'color': Colors.orange,
      },
      {
        'key': 'business',
        'label': 'Usaha',
        'icon': Icons.business_outlined,
        'color': Colors.green,
      },
      {
        'key': 'correction',
        'label': 'Koreksi',
        'icon': Icons.edit_document,
        'color': Colors.purple,
      },
      {
        'key': 'family',
        'label': 'Keluarga',
        'icon': Icons.family_restroom,
        'color': Colors.teal,
      },
      {
        'key': 'other',
        'label': 'Lainnya',
        'icon': Icons.description_outlined,
        'color': Colors.grey,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Kategori Surat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          // slightly reduce tile height (width/height closer to 1)
          childAspectRatio: 0.9,
          physics: const NeverScrollableScrollPhysics(),
          children: categories.map((cat) {
            final key = cat['key'] as String;
            // processed statuses in repo: 'diterima' and 'ditolak'
            const processed = {'diterima', 'ditolak'};
            final count = _all
                .where((r) => r.type == key && !processed.contains(r.status))
                .length;
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryRequestsScreen(
                    typeKey: key,
                    title: cat['label'] as String,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: (cat['color'] as Color),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cat['label'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<DocumentRequest> get _recentUnprocessed {
    final processed = {'diterima', 'ditolak'};
    final sorted = List<DocumentRequest>.from(_all)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.where((r) => !processed.contains(r.status)).take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kelola Pengajuan Surat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: Builder(
          builder: (context) {
            return SafeArea(
              bottom: true,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 24.0),
                children: [
                  // categories
                  _buildCategories(),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      'Pengajuan Terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._recentUnprocessed.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DocumentRequestCard(
                        request: item,
                        onView: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RequestDetailPage(
                                request: item,
                                onSaveNote: (note) async {
                                  await _repo.addNote(item.id, note);
                                  await _load();
                                },
                                onChangeStatus: (status) async {
                                  await _updateStatus(item, status);
                                },
                              ),
                            ),
                          );
                        },
                        onChangeStatus: (status) => _updateStatus(item, status),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
