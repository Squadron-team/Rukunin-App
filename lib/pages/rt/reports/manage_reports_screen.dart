import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/reports/models/report_item.dart';
import 'package:rukunin/pages/rt/reports/widgets/report_card.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/repositories/reports_repository.dart';

class ManageReportsScreen extends StatefulWidget {
  const ManageReportsScreen({super.key});

  @override
  State<ManageReportsScreen> createState() => _ManageReportsScreenState();
}

class _ManageReportsScreenState extends State<ManageReportsScreen> {
  List<ReportItem> _reports = [];
  final ReportsRepository _repo = ReportsRepository();

  void _updateStatus(ReportItem item, String status) {
    setState(() {
      item.status = status;
      _repo.updateStatus(item.id, status);
    });
  }

  void _addNote(ReportItem item) async {
    final controller = TextEditingController(text: item.note ?? '');
    final res = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambahkan Catatan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: buildInputDecoration('Catatan'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, null),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(ctx, controller.text.trim()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (res != null) {
      setState(() {
        item.note = res;
        _repo.addNote(item.id, res);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final r = await _repo.getReports();
    setState(() => _reports = r);
  }

  // Date formatting and status color helpers moved into the ReportCard widget.

  String _filter = 'all';

  Widget _buildFilterChips() {
    // compute counts for each status
    final cAll = _reports.length;
    final cNew = _reports.where((r) => r.status == 'new').length;
    final cIn = _reports.where((r) => r.status == 'in_progress').length;
    final cRes = _reports.where((r) => r.status == 'resolved').length;
    final cRej = _reports.where((r) => r.status == 'rejected').length;

    final filters = [
      {'key': 'all', 'label': 'Semua ($cAll)'},
      {'key': 'new', 'label': 'New ($cNew)'},
      {'key': 'in_progress', 'label': 'In Progress ($cIn)'},
      {'key': 'resolved', 'label': 'Resolved ($cRes)'},
      {'key': 'rejected', 'label': 'Rejected ($cRej)'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          f['label'] as String,
                          style: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : Colors.grey[800],
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kelola Laporan Warga',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Builder(
              builder: (context) {
                // compute visible list and sort once
                final visible =
                    _reports
                        .where(
                          (r) => _filter == 'all' ? true : r.status == _filter,
                        )
                        .toList()
                      ..sort((a, b) {
                        final order = {
                          'new': 0,
                          'in_progress': 1,
                          'resolved': 2,
                          'rejected': 3,
                        };
                        return (order[a.status] ?? 99).compareTo(
                          order[b.status] ?? 99,
                        );
                      });

                if (visible.isEmpty) {
                  final subtitle = _filter == 'all'
                      ? 'Belum ada laporan dari warga.'
                      : _filter == 'new'
                      ? 'Belum ada laporan baru dari warga.'
                      : _filter == 'in_progress'
                      ? 'Belum ada laporan yang sedang diproses.'
                      : _filter == 'resolved'
                      ? 'Belum ada laporan yang sudah selesai.'
                      : _filter == 'rejected'
                      ? 'Belum ada laporan yang ditolak.'
                      : 'Belum ada laporan yang masuk untuk filter ini.';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.inbox,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada laporan',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = visible[index];
                    return ReportCard(
                      item: item,
                      onAddNote: (it) => _addNote(it),
                      onStatusChange: (it, status) => _updateStatus(it, status),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
