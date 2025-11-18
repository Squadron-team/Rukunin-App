class StatusIuran {
  final String nama;
  final String nik;
  final String rt;
  final bool sudahBayar;
  final double nominal;
  final String? metodePembayaran;
  final DateTime? tanggalBayar;

  StatusIuran({
    required this.nama,
    required this.nik,
    required this.rt,
    required this.sudahBayar,
    required this.nominal,
    this.metodePembayaran,
    this.tanggalBayar,
  });
}

class DummyStatusIuranData {
  static List<StatusIuran> data = [
    StatusIuran(
      nama: "Ahmad Fauzi",
      nik: "350921xxxxxxxx",
      rt: "RT 01",
      sudahBayar: true,
      nominal: 50000,
      metodePembayaran: "Transfer",
      tanggalBayar: DateTime.now().subtract(Duration(days: 2)),
    ),
    StatusIuran(
      nama: "Siti Aisyah",
      nik: "350921xxxxxxxx",
      rt: "RT 02",
      sudahBayar: false,
      nominal: 50000,
    ),
    StatusIuran(
      nama: "Budi Santoso",
      nik: "350921xxxxxxxx",
      rt: "RT 03",
      sudahBayar: true,
      nominal: 50000,
      metodePembayaran: "Cash",
      tanggalBayar: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];
}
