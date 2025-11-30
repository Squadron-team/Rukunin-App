class TransactionsRepository {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 't_in_1',
      'kind': 'in',
      'category': 'Iuran Bulanan',
      'amount': 50000,
      'rt': 'RT 03',
      'type': 'Iuran Bulanan November',
      'name': 'Pak Budi',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'status': 'Tepat Waktu',
      'verified': true,
      'proofUrl': null,
    },
    {
      'id': 't_in_4',
      'kind': 'in',
      'category': 'Iuran Bulanan',
      'amount': 50000,
      'rt': 'RT 07',
      'type': 'Iuran Bulanan Oktober',
      'name': 'Ibu Sari',
      'time': DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      'status': 'Telat',
      'verified': true,
      'proofUrl': null,
    },
    {
      'id': 't_in_5',
      'kind': 'in',
      'category': 'Iuran Bulanan',
      'amount': 50000,
      'rt': 'RT 01',
      'type': 'Iuran Bulanan November',
      'name': 'Pak Agus',
      'time': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'Tepat Waktu',
      'verified': true,
      'proofUrl': null,
    },
    {
      'id': 't_out_1',
      'kind': 'out',
      'category': 'Operasional',
      'amount': 350000,
      'note': 'Pembelian alat kebersihan',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'proofUrl': null,
      'transaction': 'Manual',
    },
    {
      'id': 't_in_2',
      'kind': 'in',
      'category': 'Donasi Kegiatan',
      'amount': 500000,
      'note': 'Donasi untuk 17 Agustusan',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'proofUrl': null,
      'transaction': 'Manual',
    },
    {
      'id': 't_out_2',
      'kind': 'out',
      'category': 'Gaji',
      'amount': 250000,
      'note': 'Gaji petugas kebersihan',
      'time': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'proofUrl': null,
      'transaction': 'Transfer Bank',
    },
    {
      'id': 't_in_3',
      'kind': 'in',
      'category': 'Bantuan/Hibah',
      'amount': 2000000,
      'note': 'Hibah dari sponsor lokal',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'proofUrl': null,
      'transaction': 'Transfer Bank',
    },
  ];

  List<Map<String, dynamic>> all() => List<Map<String, dynamic>>.from(_items);

  List<Map<String, dynamic>> filterByKind(String kind) =>
      _items.where((e) => e['kind'] == kind).toList();

  List<Map<String, dynamic>> filterByCategory(String category) =>
      _items.where((e) => e['category'] == category).toList();

  void add(Map<String, dynamic> item) {
    _items.insert(0, item);
  }
}

final transactionsRepository = TransactionsRepository();
