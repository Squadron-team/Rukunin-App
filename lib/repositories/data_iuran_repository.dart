class DataIuranRepository {
  DataIuranRepository._();
  static final DataIuranRepository _instance = DataIuranRepository._();
  factory DataIuranRepository() => _instance;

  final List<Map<String, String>> _items = [
    {
      'id': 'iuran_1',
      'name': 'Budi Santoso',
      'rt': 'RT 1',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '10 menit yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_2',
      'name': 'Siti Aminah',
      'rt': 'RT 2',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '25 menit yang lalu',
      'color': 'blue',
      'prediction': 'palsu',
    },
    {
      'id': 'iuran_4',
      'name': 'Lina Putri',
      'rt': 'RT 4',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '2 jam yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_5',
      'name': 'Rudi Hartono',
      'rt': 'RT 5',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '3 jam yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_6',
      'name': 'Maya Sari',
      'rt': 'RT 6',
      'amount': 'Rp 100.000',
      'type': 'Iuran Bulanan - November',
      'time': '5 jam yang lalu',
      'color': 'blue',
      'prediction': 'palsu',
    },
    {
      'id': 'iuran_7',
      'name': 'Toni Kurnia',
      'rt': 'RT 7',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '6 jam yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_8',
      'name': 'Dewi Lestari',
      'rt': 'RT 8',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '8 jam yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_9',
      'name': 'Agus Salim',
      'rt': 'RT 9',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '10 jam yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_11',
      'name': 'Nur Aisyah',
      'rt': 'RT 11',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '2 hari yang lalu',
      'color': 'blue',
      'prediction': 'asli',
    },
    {
      'id': 'iuran_12',
      'name': 'Ahmad Fauzi',
      'rt': 'RT 12',
      'amount': 'Rp 50.000',
      'type': 'Iuran Bulanan - November',
      'time': '3 hari yang lalu',
      'color': 'blue',
      'prediction': 'palsu',
    },
  ];

  /// Return prediction stored for an item id: 'asli' -> true, 'palsu' -> false, otherwise null
  bool? prediction(String id) {
    final it = _items.firstWhere((e) => e['id'] == id, orElse: () => <String, String>{});
    final p = it['prediction'];
    if (p == 'asli') return true;
    if (p == 'palsu') return false;
    return null;
  }

  List<Map<String, String>> all() => List.unmodifiable(_items);

  List<Map<String, String>> pendingByRt(String rt) {
    if (rt == 'Semua') return all();
    return _items.where((e) => e['rt'] == rt).toList();
  }

  List<String> rts() {
    final s = <String>{};
    for (final it in _items) {
      s.add(it['rt'] ?? 'RT -');
    }
    final list = ['Semua'] + s.toList()..sort();
    return list;
  }

  void verify(String id) {
    _items.removeWhere((e) => e['id'] == id);
  }

  void reject(String id, String? note) {
    // For now same as verify but could record reason
    _items.removeWhere((e) => e['id'] == id);
  }
}
