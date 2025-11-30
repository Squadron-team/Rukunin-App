import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/transactions_list.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/period_selector.dart';
import 'package:rukunin/repositories/transactions_repository.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/download_options_modal.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/download_button.dart';
import 'package:rukunin/pages/treasurer/transactions/widgets/csv_preview_sheet.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  static const routeName = '/treasurer/transactions';

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTimeRange? _selectedRange;

  void _onPeriodChanged(DateTimeRange range) =>
      setState(() => _selectedRange = range);

  // --- download
  void _showDownloadOptions() {
    showDownloadOptions(context, (format) => _downloadReport(format));
  }

  Future<void> _downloadReport(String format) async {
    if (format == 'csv') {
      await _exportCsv();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Format $format belum diimplementasikan')),
    );
  }

  Future<void> _exportCsv() async {
    final idx = _tabController.index;
    String? kind;
    if (idx == 1) kind = 'in';
    if (idx == 2) kind = 'out';

    List<Map<String, dynamic>> items = kind == null
        ? transactionsRepository.all()
        : transactionsRepository.filterByKind(kind);

    final range = _selectedRange ?? _defaultRange();
    items = items.where((it) {
      final t = it['time'] as DateTime?;
      if (t == null) return false;
      if (t.isBefore(range.start)) return false;
      if (t.isAfter(range.end)) return false;
      return true;
    }).toList();

    final buffer = StringBuffer();
    buffer.writeln('id,kind,category,amount,rt,note,time');
    for (final it in items) {
      final id = it['id'] ?? '';
      final k = it['kind'] ?? '';
      final cat = (it['category'] ?? '').toString().replaceAll(',', ' ');
      final amt = it['amount']?.toString() ?? '';
      final rt = it['rt'] ?? '';
      final note = (it['note'] ?? '').toString().replaceAll(',', ' ');
      final time = (it['time'] as DateTime?)?.toIso8601String() ?? '';
      buffer.writeln('$id,$k,$cat,$amt,$rt,$note,$time');
    }

    final csv = buffer.toString();

    await showCsvPreview(context, csv);
  }

  Widget _buildDownloadButton() {
    return DownloadButton(
      isDownloading: _isDownloading,
      onTap: _showDownloadOptions,
    );
  }

  DateTimeRange _defaultRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'Riwayat Transaksi',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Pemasukan'),
              Tab(text: 'Pengeluaran'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Semua
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          PeriodSelector(onChanged: _onPeriodChanged),
                          TransactionsList(
                            kind: null,
                            start: (_selectedRange ?? _defaultRange()).start,
                            end: (_selectedRange ?? _defaultRange()).end,
                          ),
                        ],
                      ),
                    ),
                    // Pemasukan
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          PeriodSelector(onChanged: _onPeriodChanged),
                          TransactionsList(
                            kind: 'in',
                            start: (_selectedRange ?? _defaultRange()).start,
                            end: (_selectedRange ?? _defaultRange()).end,
                          ),
                        ],
                      ),
                    ),
                    // Pengeluaran
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          PeriodSelector(onChanged: _onPeriodChanged),
                          TransactionsList(
                            kind: 'out',
                            start: (_selectedRange ?? _defaultRange()).start,
                            end: (_selectedRange ?? _defaultRange()).end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Download button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: _buildDownloadButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
