import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/kegiatan/models/kegiatan.dart';

class DummyKegiatanData {
  static List<Kegiatan> kegiatanList = [
    // ======================================================
    // 🔵 DATA DUMMY TERBARU
    // ======================================================

    Kegiatan(
      id: '1',
      nama: 'Kerja Bakti Bersih Lingkungan',
      deskripsi: 'Kegiatan gotong royong membersihkan selokan, memotong rumput, dan merapikan taman di wilayah RW 05.',
      tanggal: DateTime(2025, 1, 22),
      waktu: '07:00 WIB',
      lokasi: 'Area Taman RW 05',
      kategori: 'Kebersihan',
      status: 'Akan Datang',
      peserta: 12,
      kuota: 30,
      penyelenggara: 'Ketua RW',
      kontak: '0812-3344-5566',
      iconUrl: '🧹',
      color: Colors.green,
    ),

    Kegiatan(
      id: '2',
      nama: 'Rapat Koordinasi RW',
      deskripsi: 'Rapat internal membahas program kerja 2025 dan evaluasi iuran bulanan.',
      tanggal: DateTime(2025, 1, 16),
      waktu: '19:00 WIB',
      lokasi: 'Balai RW',
      kategori: 'Sosial',
      status: 'Selesai',
      peserta: 28,
      kuota: 40,
      penyelenggara: 'Sekretaris RW',
      kontak: '0821-5556-7788',
      iconUrl: '📋',
      color: Colors.blue,
    ),

    Kegiatan(
      id: '3',
      nama: 'Senam Pagi Mingguan',
      deskripsi: 'Senam pagi bersama warga untuk meningkatkan kesehatan jasmani.',
      tanggal: DateTime(2025, 2, 3),
      waktu: '06:00 WIB',
      lokasi: 'Lapangan RW 05',
      kategori: 'Olahraga',
      status: 'Sedang Berlangsung',
      peserta: 45,
      kuota: 60,
      penyelenggara: 'Karang Taruna',
      kontak: '0877-5544-2299',
      iconUrl: '🏃',
      color: Colors.red,
    ),

    Kegiatan(
      id: '4',
      nama: 'Lomba 17 Agustus',
      deskripsi: 'Perlombaan agustusan untuk memperingati Hari Kemerdekaan Republik Indonesia.',
      tanggal: DateTime(2025, 8, 17),
      waktu: '09:00 WIB',
      lokasi: 'Lapangan RW 05',
      kategori: 'Perayaan',
      status: 'Akan Datang',
      peserta: 100,
      kuota: 200,
      penyelenggara: 'Panitia HUT RI',
      kontak: '0813-4444-8899',
      iconUrl: '🎉',
      color: Colors.orange,
    ),

    Kegiatan(
      id: '5',
      nama: 'Buka Bersama Ramadan',
      deskripsi: 'Buka puasa bersama seluruh warga RW 05.',
      tanggal: DateTime(2024, 3, 28),
      waktu: '17:30 WIB',
      lokasi: 'Masjid Al-Ikhlas',
      kategori: 'Keagamaan',
      status: 'Selesai',
      peserta: 80,
      kuota: 120,
      penyelenggara: 'Remaja Masjid',
      kontak: '0823-7799-1123',
      iconUrl: '🕌',
      color: Colors.purple,
    ),

    Kegiatan(
      id: '6',
      nama: 'Donor Darah PMI',
      deskripsi: 'Kegiatan donor darah rutin bekerja sama dengan PMI Probolinggo.',
      tanggal: DateTime(2025, 4, 10),
      waktu: '08:00 WIB',
      lokasi: 'Balai RW',
      kategori: 'Kesehatan',
      status: 'Akan Datang',
      peserta: 25,
      kuota: 50,
      penyelenggara: 'PMI + RW',
      kontak: '0852-2233-8899',
      iconUrl: '🩸',
      color: Colors.redAccent,
    ),

    Kegiatan(
      id: '7',
      nama: 'Penyuluhan Sampah Organik',
      deskripsi: 'Edukasi pengelolaan sampah organik untuk warga.',
      tanggal: DateTime(2025, 1, 29),
      waktu: '14:00 WIB',
      lokasi: 'Balai RW',
      kategori: 'Edukasi',
      status: 'Akan Datang',
      peserta: 15,
      kuota: 40,
      penyelenggara: 'PKK RW',
      kontak: '0812-7788-9922',
      iconUrl: '♻️',
      color: Colors.greenAccent,
    ),
  ];

  // ======================================================
  // 🔍 SEARCH
  // ======================================================
  static List<Kegiatan> searchKegiatan(String query) {
    if (query.isEmpty) return kegiatanList;

    final q = query.toLowerCase();

    return kegiatanList.where((k) {
      return k.nama.toLowerCase().contains(q) ||
          k.kategori.toLowerCase().contains(q) ||
          k.lokasi.toLowerCase().contains(q);
    }).toList();
  }

  // ======================================================
  // 🔎 FILTER STATUS
  // ======================================================
  static List<Kegiatan> getKegiatanByStatus(String status) {
    if (status == 'Semua') return kegiatanList;
    return kegiatanList.where((k) => k.status == status).toList();
  }

  // ======================================================
  // 📊 DATA STATISTIK
  // ======================================================
  static int getTotalKegiatan() => kegiatanList.length;

  static int getAkanDatang() =>
      kegiatanList.where((k) => k.status == 'Akan Datang').length;

  static int getSedangBerlangsung() =>
      kegiatanList.where((k) => k.status == 'Sedang Berlangsung').length;

  static int getSelesai() =>
      kegiatanList.where((k) => k.status == 'Selesai').length;
}
