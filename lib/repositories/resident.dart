import 'package:rukunin/models/resident.dart';

class WargaRepository {
  /// Generate a list of dummy warga
  static List<Warga> generateDummy({int count = 40}) {
    final List<Warga> list = [];
    final jobs = [
      'Pelajar',
      'Karyawan',
      'Wiraswasta',
      'Ibu Rumah Tangga',
      'Pensiunan',
      'Petani',
    ];
    final marriages = ['Belum Kawin', 'Kawin', 'Cerai', 'Duda/Janda'];
    final educations = ['SD', 'SMP', 'SMA', 'Diploma', 'S1', 'S2'];

    for (var i = 1; i <= count; i++) {
      final active = i % 4 != 0; // some inactive entries
      // For first 10 entries, provide sample ktp/kk asset paths (png)
      final ktp = i <= 10 ? 'assets/ktp/ktp_$i.png' : '';
      final kk = i <= 10 ? 'assets/kk/kk_$i.png' : '';

      final isHead = i % 6 == 1;
      final dob = DateTime.now().subtract(
        Duration(days: (20 + (i % 30)) * 365),
      );
      const place = 'Kota Contoh';
      final job = jobs[i % jobs.length];
      final marriage = marriages[i % marriages.length];
      final education = educations[i % educations.length];

      list.add(
        Warga(
          id: 'warga_$i',
          name: 'Warga $i',
          nik: '3276${100000000 + i}',
          kkNumber: 'KK${200000000 + i}',
          address: 'Jl. Contoh No. $i',
          // All warga shown to Community Head belong to RT 03 / RW 05
          rt: '03',
          rw: '05',
          isActive: active,
          ktpUrl: ktp,
          kkUrl: kk,
          createdAt: DateTime.now().subtract(Duration(days: i * 3)),
          isHead: isHead,
          dateOfBirth: dob,
          placeOfBirth: place,
          pekerjaan: job,
          maritalStatus: marriage,
          education: education,
        ),
      );
    }
    return list;
  }
}
