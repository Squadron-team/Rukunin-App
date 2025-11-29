class RtLetter {
  final String id;
  final String type;
  final String title;
  final String purpose;
  final DateTime createdAt;
  String status;

  RtLetter({
    required this.id,
    required this.type,
    required this.title,
    required this.purpose,
    DateTime? createdAt,
    this.status = 'pending',
  }) : createdAt = createdAt ?? DateTime.now();
}

class RtLetterRepository {
  static final List<RtLetter> _items = [];

  static List<RtLetter> all() => List.unmodifiable(_items);

  static void add(RtLetter item) {
    _items.insert(0, item);
  }

  static void clear() => _items.clear();
}
