class Mutasi {
  final String id;
  final String jenis; // 'Pindah Rumah' or 'Keluar'
  final String keluargaId;
  final String keluargaName;
  final String rumahLama;
  final String? rumahBaru;
  final String alasan;
  final DateTime tanggalMutasi;
  final DateTime createdAt;

  Mutasi({
    required this.id,
    required this.jenis,
    required this.keluargaId,
    required this.keluargaName,
    required this.rumahLama,
    this.rumahBaru,
    required this.alasan,
    required this.tanggalMutasi,
    required this.createdAt,
  });

  @override
  String toString() => 'Mutasi($id, $jenis, $keluargaName)';
}
