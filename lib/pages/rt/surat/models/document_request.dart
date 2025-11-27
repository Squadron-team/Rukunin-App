class DocumentRequest {
  final String id;
  final String type; // domicile, sktm, business, correction, family, other
  final String title;
  final String requester;
  final String purpose;
  final DateTime createdAt;
  String status; // menunggu, diterima, ditolak
  final String? rt;
  String? adminNote;
  List<String>? attachments;

  DocumentRequest({
    required this.id,
    required this.type,
    required this.title,
    required this.requester,
    required this.purpose,
    required this.createdAt,
    this.status = 'menunggu',
    this.adminNote,
    this.rt,
    this.attachments,
  });
}
