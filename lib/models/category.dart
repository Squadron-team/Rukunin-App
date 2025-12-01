class Category {
  final String id;
  String name;

  /// 'pengeluaran', 'pemasukan', 'iuran'
  String type;

  /// type == 'iuran'
  int? targetPerFamily;
  DateTime? startDate;
  DateTime? deadline;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.targetPerFamily,
    this.startDate,
    this.deadline,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'targetPerFamily': targetPerFamily,
    'startDate': startDate?.toIso8601String(),
    'deadline': deadline?.toIso8601String(),
  };

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['id'] as String,
    name: j['name'] as String,
    type: j['type'] as String,
    targetPerFamily: j['targetPerFamily'] as int?,
    startDate: j['startDate'] != null
        ? DateTime.parse(j['startDate'] as String)
        : null,
    deadline: j['deadline'] != null
        ? DateTime.parse(j['deadline'] as String)
        : null,
  );
}
