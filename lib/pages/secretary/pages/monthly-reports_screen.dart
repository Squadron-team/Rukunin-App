import 'package:flutter/material.dart';

class MonthlyReport {
  String month;
  String year;
  String summary;

  MonthlyReport({
    required this.month,
    required this.year,
    required this.summary,
  });
}

class MonthlyReportsScreen extends StatefulWidget {
  const MonthlyReportsScreen({super.key});

  @override
  State<MonthlyReportsScreen> createState() => _MonthlyReportsScreenState();
}

class _MonthlyReportsScreenState extends State<MonthlyReportsScreen> {
  final List<MonthlyReport> _reports = [
    MonthlyReport(
      month: 'Januari',
      year: '2025',
      summary: 'Laporan kegiatan Januari',
    ),
    MonthlyReport(
      month: 'Februari',
      year: '2025',
      summary: 'Laporan kegiatan Februari',
    ),
  ];

  void _deleteReport(int index) {
    setState(() {
      _reports.removeAt(index);
    });
  }

  void _showAddEditDialog({MonthlyReport? report, int? index}) {
    final monthController = TextEditingController(text: report?.month ?? '');
    final yearController = TextEditingController(text: report?.year ?? '');
    final summaryController = TextEditingController(
      text: report?.summary ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report == null ? 'Tambah Laporan' : 'Edit Laporan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: monthController,
                decoration: const InputDecoration(labelText: 'Bulan'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Tahun'),
              ),
              TextField(
                controller: summaryController,
                decoration: const InputDecoration(labelText: 'Ringkasan'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (monthController.text.isEmpty ||
                  yearController.text.isEmpty ||
                  summaryController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }

              setState(() {
                if (report == null) {
                  // Tambah baru
                  _reports.add(
                    MonthlyReport(
                      month: monthController.text,
                      year: yearController.text,
                      summary: summaryController.text,
                    ),
                  );
                } else {
                  // Edit
                  _reports[index!] = MonthlyReport(
                    month: monthController.text,
                    year: yearController.text,
                    summary: summaryController.text,
                  );
                }
              });

              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(MonthlyReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${report.month} ${report.year}'),
        content: Text(report.summary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Bulanan')),
      body: _reports.isEmpty
          ? const Center(child: Text('Belum ada laporan bulanan'))
          : ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('${report.month} ${report.year}'),
                    subtitle: Text(report.summary),
                    onTap: () => _showDetailDialog(report),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showAddEditDialog(report: report, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReport(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
