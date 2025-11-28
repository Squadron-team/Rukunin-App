import 'package:rukunin/pages/rt/surat_form_warga/models/document_request.dart';

class DocumentRequestsRepository {
  static final DocumentRequestsRepository _instance =
      DocumentRequestsRepository._internal();
  factory DocumentRequestsRepository() => _instance;

  DocumentRequestsRepository._internal() {
    _initDemo();
  }

  final List<DocumentRequest> _store = [];

  void _initDemo() {
    _store.addAll([
      DocumentRequest(
        id: 'd1',
        type: 'domicile',
        title: 'Surat Keterangan Domisili',
        requester: 'Andi',
        purpose: 'Untuk syarat sekolah anak',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        attachments: ['domisili_andI.pdf'],
      ),
      DocumentRequest(
        id: 'd2',
        type: 'sktm',
        title: 'Surat Keterangan Tidak Mampu',
        requester: 'Siti',
        purpose: 'Pengajuan bantuan',
        createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        status: 'menunggu',
        attachments: ['ktp_siti.jpg'],
      ),
      DocumentRequest(
        id: 'd3',
        type: 'business',
        title: 'Surat Keterangan Usaha',
        requester: 'Budi',
        purpose: 'Mengurus perizinan usaha rumahan',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'diterima',
        adminNote: 'Silakan ambil ke kantor RT',
        attachments: ['izin_usaha_budi.pdf'],
      ),
      DocumentRequest(
        id: 'd4',
        type: 'correction',
        title: 'Permohonan Koreksi Data',
        requester: 'Rina',
        purpose: 'Koreksi data KTP',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: 'menunggu',
      ),
      // intentionally do NOT add any 'family' type items so UI shows empty state for that category
      DocumentRequest(
        id: 'd6',
        type: 'other',
        title: 'Pengajuan Surat Lainnya',
        requester: 'Lina',
        purpose: 'Keperluan umum',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: 'ditolak',
        adminNote: 'Dokumen tidak lengkap',
      ),
      // add more demo requests
      DocumentRequest(
        id: 'd7',
        type: 'domicile',
        title: 'Surat Keterangan Domisili',
        requester: 'Ardi',
        purpose: 'Pendaftaran sekolah',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        attachments: ['kk_ardi.jpg'],
      ),
      DocumentRequest(
        id: 'd8',
        type: 'sktm',
        title: 'Surat Keterangan Tidak Mampu',
        requester: 'Dewi',
        purpose: 'Bantuan biaya',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        status: 'menunggu',
      ),
      DocumentRequest(
        id: 'd9',
        type: 'business',
        title: 'Surat Keterangan Usaha',
        requester: 'Sumarno',
        purpose: 'Izin usaha kaki lima',
        createdAt: DateTime.now().subtract(const Duration(hours: 30)),
      ),
      DocumentRequest(
        id: 'd10',
        type: 'correction',
        title: 'Permohonan Koreksi Data',
        requester: 'Tini',
        purpose: 'Perbaikan data keluarga',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        status: 'diterima',
      ),
      // more demo requests (domicile, sktm, business, correction, other)
      DocumentRequest(
        id: 'd13',
        type: 'domicile',
        title: 'Surat Keterangan Domisili',
        requester: 'Maya',
        purpose: 'Pendaftaran anak TK',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      DocumentRequest(
        id: 'd14',
        type: 'domicile',
        title: 'Surat Keterangan Domisili',
        requester: 'Hendra',
        purpose: 'Pengurusan beasiswa',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      DocumentRequest(
        id: 'd15',
        type: 'sktm',
        title: 'Surat Keterangan Tidak Mampu',
        requester: 'Iwan',
        purpose: 'Bantuan sosial',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'menunggu',
      ),
      DocumentRequest(
        id: 'd16',
        type: 'sktm',
        title: 'Surat Keterangan Tidak Mampu',
        requester: 'Sari',
        purpose: 'Pendaftaran program bantuan',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      DocumentRequest(
        id: 'd17',
        type: 'business',
        title: 'Surat Keterangan Usaha',
        requester: 'Joko',
        purpose: 'Izin lapak makanan',
        createdAt: DateTime.now().subtract(const Duration(hours: 36)),
      ),
      DocumentRequest(
        id: 'd18',
        type: 'business',
        title: 'Surat Keterangan Usaha',
        requester: 'Lina',
        purpose: 'Perpanjangan izin usaha',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      DocumentRequest(
        id: 'd19',
        type: 'correction',
        title: 'Permohonan Koreksi Data',
        requester: 'Widi',
        purpose: 'Perbaikan nama di KTP',
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
        status: 'diterima',
      ),
      DocumentRequest(
        id: 'd20',
        type: 'other',
        title: 'Pengajuan Surat Lainnya',
        requester: 'Tono',
        purpose: 'Permohonan surat pengantar',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        status: 'menunggu',
      ),
      DocumentRequest(
        id: 'd21',
        type: 'other',
        title: 'Pengajuan Surat Lainnya',
        requester: 'Rika',
        purpose: 'Pengajuan umum',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        status: 'menunggu',
      ),
      DocumentRequest(
        id: 'd12',
        type: 'other',
        title: 'Pengajuan Surat Lainnya',
        requester: 'Rudi',
        purpose: 'Permohonan acak',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        status: 'menunggu',
      ),
    ]);
  }

  Future<List<DocumentRequest>> getRequests() async {
    return List<DocumentRequest>.from(_store);
  }

  Future<void> updateStatus(String id, String status) async {
    final idx = _store.indexWhere((e) => e.id == id);
    if (idx != -1) _store[idx].status = status;
  }

  Future<void> addNote(String id, String note) async {
    final idx = _store.indexWhere((e) => e.id == id);
    if (idx != -1) _store[idx].adminNote = note;
  }

  Future<void> addAttachment(String id, String filename) async {
    final idx = _store.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final cur = _store[idx].attachments;
      if (cur == null) {
        _store[idx].attachments = [filename];
      } else {
        cur.add(filename);
      }
    }
  }
}
