class ReportItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final String reporter;
  final DateTime createdAt;
  String status; // 'new', 'in_progress', 'resolved', 'rejected'
  String? note;

  ReportItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.reporter,
    required this.createdAt,
    this.status = 'new',
    this.note,
  });
}
