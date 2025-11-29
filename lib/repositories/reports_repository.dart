import 'package:rukunin/pages/rt/reports/models/report_item.dart';

class ReportsRepository {
  static final ReportsRepository _instance = ReportsRepository._internal();
  factory ReportsRepository() => _instance;

  ReportsRepository._internal() {
    _initDemo();
  }

  final List<ReportItem> _store = [];

  void _initDemo() {
    _store.addAll([
      ReportItem(
        id: 'r1',
        title: 'Lampu jalan mati di Gang Dahlia',
        description:
            'Lampu jalan di gang dahlia padam sejak semalam, rawan kecelakaan.',
        location: 'Gang Dahlia',
        reporter: 'Budi Santoso',
        createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      ReportItem(
        id: 'r2',
        title: 'PDAM mati di RT 05',
        description: 'Air PDAM putus sejak pagi, warga kesulitan air bersih.',
        location: 'RT 05',
        reporter: 'Siti Aminah',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      ReportItem(
        id: 'r3',
        title: 'Ular ditemukan di sawah belakang SD',
        description:
            'Ada ular besar di area persawahan dekat SD, mohon ditangani.',
        location: 'Sawah belakang SD',
        reporter: 'Anton',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      ReportItem(
        id: 'r4',
        title: 'Jalan berlubang di Jl. Mawar',
        description:
            'Berlubang besar di depan rumah nomor 12, berbahaya untuk motor.',
        location: 'Jl. Mawar',
        reporter: 'Dewi',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  Future<List<ReportItem>> getReports() async {
    // for demo keep synchronous-ish but return Future
    return List<ReportItem>.from(_store);
  }

  Future<void> updateStatus(String id, String status) async {
    final idx = _store.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _store[idx].status = status;
    }
  }

  Future<void> addNote(String id, String note) async {
    final idx = _store.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _store[idx].note = note;
    }
  }
}
