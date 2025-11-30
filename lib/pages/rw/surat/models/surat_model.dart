enum StatusSurat { menunggu, disetujui, ditolak }

extension StatusSuratExtension on StatusSurat {
  String get displayName {
    switch (this) {
      case StatusSurat.menunggu:
        return 'Menunggu';
      case StatusSurat.disetujui:
        return 'Disetujui';
      case StatusSurat.ditolak:
        return 'Ditolak';
    }
  }
}

class Surat {
  final String jenis;
  final String pemohon;
  final String tanggal;
  final StatusSurat status;
  final String nomor;
  final String? keterangan;
  final String? alamat;
  final String? keperluan;

  Surat({
    required this.jenis,
    required this.pemohon,
    required this.tanggal,
    required this.status,
    required this.nomor,
    this.keterangan,
    this.alamat,
    this.keperluan,
  });
}
