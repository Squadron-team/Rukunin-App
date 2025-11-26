import 'package:flutter/material.dart';
import 'package:rukunin/repositories/document_requests_repository.dart';
import 'package:rukunin/pages/rt/surat/models/document_request.dart';
import 'package:rukunin/pages/rt/surat/widgets/document_request_card.dart';
import 'package:rukunin/pages/rt/surat/widgets/request_detail_page.dart';
import 'package:rukunin/style/app_colors.dart';

class CategoryRequestsScreen extends StatefulWidget {
  final String typeKey;
  final String title;
  const CategoryRequestsScreen({Key? key, required this.typeKey, required this.title}) : super(key: key);

  @override
  State<CategoryRequestsScreen> createState() => _CategoryRequestsScreenState();
}

class _CategoryRequestsScreenState extends State<CategoryRequestsScreen> {
  final DocumentRequestsRepository _repo = DocumentRequestsRepository();
  List<DocumentRequest> _items = [];

  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await _repo.getRequests();
    setState(() => _items = all.where((e) => e.type == widget.typeKey).toList());
  }

  Future<void> _updateStatus(DocumentRequest item, String status) async {
    await _repo.updateStatus(item.id, status);
    await _load();
  }

  Widget _buildFilterChips() {
    final cAll = _items.length;
    final cMenunggu = _items.where((r) => r.status == 'menunggu').length;
    final cDiterima = _items.where((r) => r.status == 'diterima').length;
    final cDitolak = _items.where((r) => r.status == 'ditolak').length;

    final filters = [
      {'key': 'all', 'label': 'Semua ($cAll)'},
      {'key': 'menunggu', 'label': 'Menunggu ($cMenunggu)'},
      {'key': 'diterima', 'label': 'Diterima ($cDiterima)'},
      {'key': 'ditolak', 'label': 'Ditolak ($cDitolak)'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: SizedBox(
        height: 44,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              final selected = _filter == f['key'];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f['key'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: Row(children: [
                      Text(f['label'] as String, style: TextStyle(color: selected ? AppColors.primary : Colors.grey[800], fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _shortTitle() {
    // Use abbreviations for certain document types; default to provided title
    switch (widget.typeKey) {
      case 'sktm':
        return 'SKTM';
      case 'domicile':
        return 'Domisili';
      case 'business':
        return 'Izin';
      case 'correction':
        return 'Koreksi';
      case 'family':
        return 'Keluarga';
      default:
        return widget.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _shortTitle(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Builder(builder: (context) {
                final visible = _items.where((r) => _filter == 'all' ? true : r.status == _filter).toList();

                if (visible.isEmpty) {
                  final subtitle = _filter == 'all'
                      ? 'Belum ada pengajuan untuk kategori ini.'
                      : _filter == 'menunggu'
                          ? 'Belum ada pengajuan menunggu.'
                          : _filter == 'diterima'
                              ? 'Belum ada pengajuan yang disetujui.'
                              : _filter == 'ditolak'
                                  ? 'Belum ada pengajuan yang ditolak.'
                                  : 'Belum ada pengajuan untuk filter ini.';

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
                          child: Icon(Icons.description_outlined, size: 44, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text('Belum ada pengajuan', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (c, i) {
                      final item = visible[i];
                      return DocumentRequestCard(
                        request: item,
                        onView: () async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => RequestDetailPage(
                                request: item,
                                onSaveNote: (note) async {
                                  await _repo.addNote(item.id, note);
                                  await _load();
                                },
                                onChangeStatus: (status) async {
                                  await _updateStatus(item, status);
                                },
                              )));
                        },
                        onChangeStatus: (status) => _updateStatus(item, status),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
