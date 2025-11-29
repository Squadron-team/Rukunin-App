class DocumentRequest {
  final String id;
  final String type; // domicile, sktm, business, correction, family, other
  final String title;
  final String requester;
  final String purpose;
  final DateTime createdAt;
  String status; // menunggu, diterima, ditolak
  final String? rt;
  String? note;
  List<String>? attachments;

  DocumentRequest({
    required this.id,
    required this.type,
    required this.title,
    required this.requester,
    required this.purpose,
    required this.createdAt,
    this.status = 'menunggu',
    this.note,
    this.rt,
    this.attachments,
  });
}
