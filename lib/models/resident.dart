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

  // Additional attributes
  final bool isHead; // true = kepala keluarga
  final DateTime? dateOfBirth;
  final String placeOfBirth;
  final String pekerjaan;
  final String maritalStatus;
  final String education;

  Warga({
    required this.id,
    required this.name,
    required this.nik,
    required this.kkNumber,
    required this.address,
    required this.isActive,
    required this.ktpUrl,
    required this.kkUrl,
    required this.createdAt,
    this.rt = '01',
    this.rw = '01',
    this.isHead = false,
    this.dateOfBirth,
    this.placeOfBirth = '',
    this.pekerjaan = '',
    this.maritalStatus = '',
    this.education = '',
  });
}
