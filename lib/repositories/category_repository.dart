import 'package:collection/collection.dart';
import 'package:rukunin/models/category.dart';
import 'package:rukunin/repositories/data_iuran_repository.dart';

class CategoryRepository {
  static final CategoryRepository _instance = CategoryRepository._internal();
  factory CategoryRepository() => _instance;
  CategoryRepository._internal() {
    // seed default categories
    if (_items.isEmpty) {
      _items.addAll([
        // Pengeluaran
        Category(id: 'p1', name: 'kegiatan/acara', type: 'pengeluaran'),
        Category(id: 'p2', name: 'pemeliharaan fasilitas', type: 'pengeluaran'),
        Category(id: 'p3', name: 'operasional', type: 'pengeluaran'),
        Category(id: 'p4', name: 'gaji', type: 'pengeluaran'),
        Category(id: 'p5', name: 'lain-lain', type: 'pengeluaran'),
        // Pemasukan
        Category(id: 'm1', name: 'bantuan/hibah', type: 'pemasukan'),
        Category(id: 'm2', name: 'donasi kegiatan', type: 'pemasukan'),
        Category(id: 'm3', name: 'pendapatan lain', type: 'pemasukan'),
        // Iuran warga (contoh beberapa bulan)
        Category(
          id: 'i2025-10',
          name: 'Iuran Bulanan Oktober 2025',
          type: 'iuran',
          targetPerFamily: 50000,
          startDate: DateTime(2025, 10, 1),
          deadline: DateTime(2025, 10, 31),
        ),
        Category(
          id: 'i2025-11',
          name: 'Iuran Bulanan November 2025',
          type: 'iuran',
          targetPerFamily: 50000,
          startDate: DateTime(2025, 11, 1),
          deadline: DateTime(2025, 11, 30),
        ),
        Category(
          id: 'i2025-12',
          name: 'Iuran Bulanan Desember 2025',
          type: 'iuran',
          targetPerFamily: 50000,
          startDate: DateTime(2025, 12, 1),
          deadline: DateTime(2025, 12, 31),
        ),
        Category(
          id: 'i2025-special',
          name: 'Iuran Dana Gotong Royong 2025',
          type: 'iuran',
          targetPerFamily: 75000,
          startDate: DateTime(2025, 9, 1),
          deadline: DateTime(2025, 9, 30),
        ),
      ]);
    }
  }

  final List<Category> _items = [];

  List<Category> all() => List.unmodifiable(_items);

  List<Category> byType(String type) =>
      _items.where((c) => c.type == type).toList();

  Category? findById(String id) => _items.firstWhereOrNull((c) => c.id == id);

  void add(Category c) {
    _items.insert(0, c);
  }

  void update(Category c) {
    final idx = _items.indexWhere((e) => e.id == c.id);
    if (idx >= 0) _items[idx] = c;
  }

  bool hasRelated(Category c) {
    try {
      final iurans = DataIuranRepository().all();
      final exists = iurans.any(
        (e) =>
            (e['categoryId'] ?? '') == c.id || (e['category'] ?? '') == c.name,
      );
      if (exists) return true;
    } catch (_) {}
    return false;
  }

  bool remove(Category c) {
    if (hasRelated(c)) return false;
    return _items.remove(c);
  }
}
