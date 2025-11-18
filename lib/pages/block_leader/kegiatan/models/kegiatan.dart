import 'package:flutter/material.dart';

class Kegiatan {
  final String id;
  final String nama;
  final String deskripsi;
  final DateTime tanggal;
  final String waktu;
  final String lokasi;
  final String kategori;
  final String status;
  final int peserta;
  final int kuota;
  final String penyelenggara;
  final String kontak;
  final String iconUrl;
  final Color color;

  Kegiatan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.kategori,
    required this.status,
    required this.peserta,
    required this.kuota,
    required this.penyelenggara,
    required this.kontak,
    required this.iconUrl,
    required this.color,
  });
}
