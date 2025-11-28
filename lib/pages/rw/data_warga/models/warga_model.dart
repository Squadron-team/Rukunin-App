class Warga {
  final String id;
  final String nama;
  final String nik;
  final String alamat;
  final String rt;
  final String rw;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String noTelepon;
  final String pekerjaan;
  final String statusPerkawinan;
  final String fotoUrl;

  Warga({
    required this.id,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.pekerjaan,
    required this.statusPerkawinan,
    this.noTelepon = '-',
    this.fotoUrl = '',
  });

  // Copy with method untuk update data
  Warga copyWith({
    String? id,
    String? nama,
    String? nik,
    String? alamat,
    String? rt,
    String? rw,
    String? jenisKelamin,
    String? tempatLahir,
    String? tanggalLahir,
    String? noTelepon,
    String? pekerjaan,
    String? statusPerkawinan,
    String? fotoUrl,
  }) {
    return Warga(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      alamat: alamat ?? this.alamat,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      noTelepon: noTelepon ?? this.noTelepon,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}

// Data Dummy Warga
class DummyWargaData {
  static List<Warga> wargaList = [
    Warga(
      id: '1',
      nama: 'Ahmad Wijaya',
      nik: '3201012345670001',
      alamat: 'Jl. Merdeka No. 12',
      rt: '01',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Jakarta',
      tanggalLahir: '15-03-1985',
      noTelepon: '081234567890',
      pekerjaan: 'Wiraswasta',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Ahmad+Wijaya&background=4F46E5&color=fff&size=200',
    ),
    Warga(
      id: '2',
      nama: 'Siti Nurhaliza',
      nik: '3201012345670002',
      alamat: 'Jl. Merdeka No. 15',
      rt: '01',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Bandung',
      tanggalLahir: '22-07-1990',
      noTelepon: '081234567891',
      pekerjaan: 'Guru',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Siti+Nurhaliza&background=EC4899&color=fff&size=200',
    ),
    Warga(
      id: '3',
      nama: 'Budi Santoso',
      nik: '3201012345670003',
      alamat: 'Jl. Merdeka No. 18',
      rt: '02',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Surabaya',
      tanggalLahir: '10-11-1988',
      noTelepon: '081234567892',
      pekerjaan: 'PNS',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Budi+Santoso&background=10B981&color=fff&size=200',
    ),
    Warga(
      id: '4',
      nama: 'Dewi Lestari',
      nik: '3201012345670004',
      alamat: 'Jl. Merdeka No. 25',
      rt: '02',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Yogyakarta',
      tanggalLahir: '05-04-1992',
      noTelepon: '081234567893',
      pekerjaan: 'Dokter',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Dewi+Lestari&background=F59E0B&color=fff&size=200',
    ),
    Warga(
      id: '5',
      nama: 'Eko Prasetyo',
      nik: '3201012345670005',
      alamat: 'Jl. Melati No. 8',
      rt: '03',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Semarang',
      tanggalLahir: '18-09-1995',
      noTelepon: '081234567894',
      pekerjaan: 'Software Developer',
      statusPerkawinan: 'Belum Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Eko+Prasetyo&background=6366F1&color=fff&size=200',
    ),
    Warga(
      id: '6',
      nama: 'Fitri Handayani',
      nik: '3201012345670006',
      alamat: 'Jl. Melati No. 12',
      rt: '03',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Malang',
      tanggalLahir: '28-12-1993',
      noTelepon: '081234567895',
      pekerjaan: 'Pengusaha',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Fitri+Handayani&background=EF4444&color=fff&size=200',
    ),
    Warga(
      id: '7',
      nama: 'Gunawan Hidayat',
      nik: '3201012345670007',
      alamat: 'Jl. Mawar No. 5',
      rt: '04',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Medan',
      tanggalLahir: '14-06-1987',
      noTelepon: '081234567896',
      pekerjaan: 'Arsitek',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Gunawan+Hidayat&background=8B5CF6&color=fff&size=200',
    ),
    Warga(
      id: '8',
      nama: 'Hesti Pratiwi',
      nik: '3201012345670008',
      alamat: 'Jl. Mawar No. 10',
      rt: '04',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Palembang',
      tanggalLahir: '08-02-1991',
      noTelepon: '081234567897',
      pekerjaan: 'Desainer',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Hesti+Pratiwi&background=14B8A6&color=fff&size=200',
    ),
    Warga(
      id: '9',
      nama: 'Irfan Maulana',
      nik: '3201012345670009',
      alamat: 'Jl. Anggrek No. 3',
      rt: '05',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Makassar',
      tanggalLahir: '20-10-1996',
      noTelepon: '081234567898',
      pekerjaan: 'Marketing',
      statusPerkawinan: 'Belum Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Irfan+Maulana&background=F97316&color=fff&size=200',
    ),
    Warga(
      id: '10',
      nama: 'Julia Safitri',
      nik: '3201012345670010',
      alamat: 'Jl. Anggrek No. 7',
      rt: '05',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Padang',
      tanggalLahir: '12-05-1994',
      noTelepon: '081234567899',
      pekerjaan: 'Akuntan',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Julia+Safitri&background=EC4899&color=fff&size=200',
    ),
    Warga(
      id: '11',
      nama: 'Kurniawan Setiawan',
      nik: '3201012345670011',
      alamat: 'Jl. Dahlia No. 15',
      rt: '06',
      rw: '05',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Bogor',
      tanggalLahir: '03-08-1989',
      noTelepon: '081234567800',
      pekerjaan: 'Insinyur',
      statusPerkawinan: 'Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Kurniawan+Setiawan&background=3B82F6&color=fff&size=200',
    ),
    Warga(
      id: '12',
      nama: 'Linda Wijayanti',
      nik: '3201012345670012',
      alamat: 'Jl. Dahlia No. 20',
      rt: '06',
      rw: '05',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Tangerang',
      tanggalLahir: '25-01-1997',
      noTelepon: '081234567801',
      pekerjaan: 'Perawat',
      statusPerkawinan: 'Belum Menikah',
      fotoUrl:
          'https://ui-avatars.com/api/?name=Linda+Wijayanti&background=A855F7&color=fff&size=200',
    ),
  ];

  // Get all warga
  static List<Warga> getAllWarga() {
    return wargaList;
  }

  // Get warga by ID
  static Warga? getWargaById(String id) {
    try {
      return wargaList.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new warga
  static void addWarga(Warga warga) {
    wargaList.add(warga);
  }

  // Update warga
  static void updateWarga(String id, Warga updatedWarga) {
    final index = wargaList.indexWhere((w) => w.id == id);
    if (index != -1) {
      wargaList[index] = updatedWarga;
    }
  }

  // Delete warga
  static void deleteWarga(String id) {
    wargaList.removeWhere((w) => w.id == id);
  }

  // Search warga
  static List<Warga> searchWarga(String query) {
    if (query.isEmpty) return wargaList;

    return wargaList.where((w) {
      return w.nama.toLowerCase().contains(query.toLowerCase()) ||
          w.nik.contains(query) ||
          w.alamat.toLowerCase().contains(query.toLowerCase()) ||
          w.rt.contains(query);
    }).toList();
  }

  // Filter by RT
  static List<Warga> filterByRT(String rt) {
    if (rt.isEmpty || rt == 'Semua') return wargaList;
    return wargaList.where((w) => w.rt == rt).toList();
  }

  // Get total warga count
  static int getTotalWarga() {
    return wargaList.length;
  }
}
