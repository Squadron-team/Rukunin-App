// lib/laporan/kelola_laporan_screen.dart
import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/laporan/widgets/rt_item_card.dart';
import 'package:rukunin/pages/rw/laporan/widgets/rw_item_card.dart';
import 'package:rukunin/pages/rw/laporan/widgets/rekap_summary_card.dart';
import 'package:rukunin/pages/rw/laporan/data/dummy_data.dart';

class KelolaLaporanScreen extends StatefulWidget {
  const KelolaLaporanScreen({super.key});

  @override
  State<KelolaLaporanScreen> createState() => _KelolaLaporanScreenState();
}

class _KelolaLaporanScreenState extends State<KelolaLaporanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Kelola Laporan'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Laporan RT'),
            Tab(text: 'Laporan RW'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _laporanRTView(),
          _laporanRWView(),
        ],
      ),
    );
  }

  Widget _laporanRTView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: DummyData.rtReports
          .map((report) => RTItemCard(
                report: report,
                onTap: () => _showDetailRT(context, report),
              ))
          .toList(),
    );
  }

  Widget _laporanRWView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RekapSummaryCard(rekap: DummyData.rekap),
        const SizedBox(height: 20),
        const Text(
          'Daftar Laporan Warga',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...DummyData.rwReports.map((report) => RWItemCard(
              report: report,
              onTap: () => _showDetailRW(context, report),
            )),
      ],
    );
  }

  // ====================== DETAIL DIALOG ======================
  void _showDetailRT(BuildContext context, dynamic report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Laporan ${report.rt}', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.format_list_numbered, 'Total Laporan', report.total.toString()),
            const SizedBox(height: 8),
            _infoRow(Icons.check_circle, 'Selesai', report.selesai.toString(), color: Colors.green),
            const SizedBox(height: 8),
            _infoRow(Icons.access_time, 'Belum Selesai', (report.total - report.selesai).toString(), color: Colors.orange),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup', style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }

  void _showDetailRW(BuildContext context, dynamic report) {
    Color statusColor = _getStatusColor(report.status);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(report.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.home, 'Dari RT', report.rt),
            const SizedBox(height: 8),
            _infoRow(Icons.info, 'Status', report.status, color: statusColor),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup', style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: color ?? Colors.black87)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai': return Colors.green;
      case 'Proses': return Colors.orange;
      case 'Menunggu': return Colors.red;
      default: return Colors.grey;
    }
  }
}