import 'package:rukunin/models/announcementRT.dart';

final List<Announcement> announcements = [
  Announcement(
    id: 'a1',
    title: 'Jadwal Fogging RW 03',
    body:
        'Akan dilaksanakan fogging pada hari Sabtu pukul 08:00 di RT 03. Mohon warga bersiap.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a2',
    title: 'Perbaikan Jalan Usaha',
    body:
        'Perbaikan jalan di gang 4 dimulai besok. Mohon parkir kendaraan di tempat aman.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a10',
    title: 'Listrik Padam Sementara',
    body:
        'PLN akan memadamkan listrik di RT 03 mulai pukul 22:00 hingga 01:00 untuk perbaikan jaringan.',
    createdAt: DateTime.now().subtract(const Duration(seconds: 45)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a9',
    title: 'Pengumuman Siskamling',
    body:
        'Jadwal ronda malam minggu ini dimulai pukul 20:00. Mohon ketua RT RT 03 hadir.',
    createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a8',
    title: 'Kerja Bakti Minggu',
    body:
        'Kerja bakti bersih-bersih lingkungan di balai warga, kumpul pukul 07:00.',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a7',
    title: 'Pengingat Iuran Bulanan',
    body:
        'Iuran bulan ini diharapkan disetor paling lambat tanggal 30 November.',
    createdAt: DateTime.now().subtract(const Duration(hours: 26)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a6',
    title: 'Penutupan Jalan Sementara',
    body:
        'Jalan gang 2 ditutup sementara untuk perbaikan saluran air mulai besok pagi.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a5',
    title: 'Fogging Rutin',
    body:
        'Dilakukan fogging pada hari Sabtu; mohon warga membuka jendela untuk memudahkan proses.',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a4',
    title: 'Gangguan Air Bersih',
    body:
        'Distribusi air terganggu karena pemeliharaan pipa; diperkirakan pulih dalam 2 hari.',
    createdAt: DateTime.now().subtract(const Duration(days: 40)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a3',
    title: 'Peringatan Musim Hujan',
    body:
        'Waspada genangan di area RT 03; simpan barang berharga di tempat aman.',
    createdAt: DateTime.now().subtract(const Duration(days: 92)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a2',
    title: 'Perbaikan Jalan Usaha',
    body:
        'Perbaikan jalan di gang 4 dimulai besok. Mohon parkir kendaraan di tempat aman.',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    author: 'Ketua RT',
  ),
  Announcement(
    id: 'a1',
    title: 'Jadwal Fogging RW 03',
    body:
        'Akan dilaksanakan fogging pada hari Sabtu pukul 08:00 di RT 03. Mohon warga bersiap.',
    createdAt: DateTime.now().subtract(const Duration(days: 400)),
    author: 'Ketua RT',
  ),
];

void addAnnouncement(Announcement a) {
  announcements.insert(0, a);
}
