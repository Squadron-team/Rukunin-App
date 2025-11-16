class Warga {
  final String id;
  final String name;
  final String nik;
  final String kkNumber;
  final String address;
  final String rt;
  final String rw;
  final bool isActive;
  final String ktpUrl;
  final String kkUrl;
  final DateTime createdAt;

  Warga({
    required this.id,
    required this.name,
    required this.nik,
    required this.kkNumber,
    required this.address,
    this.rt = '01',
    this.rw = '01',
    required this.isActive,
    required this.ktpUrl,
    required this.kkUrl,
    required this.createdAt,
  });
}
