import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/date_formatter.dart';

List<Event> events = [
  Event(
    category: 'Pendidikan',
    title: 'Pelatihan UMKM',
    location: 'Rumah Bu Rosi',
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: -12)),
    ),
    time: '09:00 - 12:00',
    categoryColor: const Color(0xFFBDBDBD),
    description:
        'Pelatihan UMKM ini bertujuan untuk membantu warga mengembangkan usaha kecil mereka agar lebih produktif dan berdaya saing. Peserta akan mempelajari dasar-dasar pemasaran, pengelolaan keuangan, dan strategi penjualan sederhana.\n\n'
        'Yang akan dipelajari:\n'
        '• Cara mengelola keuangan usaha\n'
        '• Tips pemasaran efektif untuk pemula\n'
        '• Strategi meningkatkan kualitas produk\n\n'
        'Peserta diharapkan membawa alat tulis untuk mencatat materi.',
  ),
  Event(
    category: 'Sosial',
    title: 'Kerja Bakti',
    location: 'Balai Warga',
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: -3)),
    ),
    time: '07:00 - 10:00',
    categoryColor: AppColors.primary,
    description:
        'Mari bergotong royong membersihkan lingkungan sekitar balai warga untuk menjaga kebersihan dan kesehatan bersama. Kegiatan ini akan dilakukan di area sekitar balai dan jalan utama.\n\n'
        'Yang perlu dibawa:\n'
        '• Sapu\n'
        '• Sarung tangan\n'
        '• Kantong sampah\n\n'
        'Air minum dan snack akan disediakan oleh panitia.',
  ),
  Event(
    title: 'Kerja Bakti Lingkungan',
    category: 'Sosial',
    categoryColor: Colors.green,
    date: DateFormatter.formatFull(DateTime.now()),
    time: '07:00 - 10:00',
    location: 'Taman Warga RW 05',
    description:
        'Kegiatan kerja bakti ini difokuskan pada pembersihan taman warga RW 05 serta perbaikan fasilitas umum seperti bangku taman dan area bermain anak.\n\n'
        'Agenda kegiatan:\n'
        '• Pemangkasan tanaman\n'
        '• Pembersihan area taman\n'
        '• Pengecatan ulang bangku taman\n\n'
        'Dimohon hadir tepat waktu untuk pembagian tugas.',
  ),
  Event(
    title: 'Rapat RT Bulanan',
    category: 'Rapat',
    categoryColor: Colors.blue,
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: 2)),
    ),
    time: '19:00 - 21:00',
    location: 'Balai RT 03',
    description:
        'Rapat rutin RT 03 untuk membahas perkembangan kegiatan bulan ini dan rencana kegiatan bulan depan. Seluruh warga diundang untuk berpartisipasi menyampaikan aspirasi dan masukan.\n\n'
        'Agenda rapat:\n'
        '• Evaluasi kegiatan bulan sebelumnya\n'
        '• Pembahasan anggaran kas RT\n'
        '• Persiapan kegiatan akhir tahun\n\n'
        'Harap hadir minimal satu per rumah.',
  ),
  Event(
    title: 'Senam Sehat Bersama',
    category: 'Olahraga',
    categoryColor: Colors.orange,
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: 2)),
    ),
    time: '06:00 - 07:30',
    location: 'Lapangan RW',
    description:
        'Ayo ikut senam sehat bersama warga untuk menjaga kebugaran tubuh! Senam akan dipandu oleh instruktur berpengalaman dan cocok untuk semua umur.\n\n'
        'Yang disarankan dibawa:\n'
        '• Handuk kecil\n'
        '• Botol minum\n'
        '• Baju olahraga yang nyaman\n\n'
        'Tersedia doorprize menarik bagi peserta yang hadir.',
  ),
  Event(
    title: 'Pelatihan Kewirausahaan',
    category: 'Pendidikan',
    categoryColor: Colors.purple,
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: 5))),
    time: '13:00 - 16:00',
    location: 'Balai RW 05',
    description:
        'Pelatihan ini ditujukan bagi warga yang ingin memulai usaha mandiri ataupun mengembangkan usaha rumahan yang sudah berjalan. Materi disampaikan dengan metode praktis dan mudah dipahami.\n\n'
        'Materi pelatihan:\n'
        '• Menentukan ide bisnis yang tepat\n'
        '• Cara membuat perencanaan usaha\n'
        '• Teknik promosi online sederhana\n\n'
        'Peserta akan mendapatkan modul digital sebagai bahan belajar.',
  ),
  Event(
    title: 'Festival Seni & Budaya',
    category: 'Seni',
    categoryColor: Colors.pink,
    date: DateFormatter.formatFull(
      DateTime.now().add(const Duration(days: 7))),
    time: '15:00 - 20:00',
    location: 'Gedung Serbaguna',
    description:
        'Festival tahunan yang menampilkan berbagai pertunjukan seni dan budaya lokal. Warga dapat menikmati tarian tradisional, pameran kerajinan tangan, serta beragam kuliner khas daerah.\n\n'
        'Rangkaian acara:\n'
        '• Tari tradisional pembuka\n'
        '• Pameran UMKM lokal\n'
        '• Stand makanan khas daerah\n'
        '• Lomba kostum budaya\n\n'
        'Acara ini terbuka untuk semua warga tanpa biaya masuk.',
  ),
];
