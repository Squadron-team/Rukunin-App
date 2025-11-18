// lib/laporan/data/dummy_data.dart
import '../models/rt_report.dart';
import '../models/rw_report.dart';

class DummyData {
  static final List<RTReport> rtReports = [
    RTReport(rt: "RT 01", total: 12, selesai: 8),
    RTReport(rt: "RT 02", total: 7, selesai: 5),
    RTReport(rt: "RT 03", total: 15, selesai: 11),
    RTReport(rt: "RT 04", total: 9, selesai: 4),
  ];

  static final List<RWReport> rwReports = [
    RWReport(judul: "Jalan Rusak", rt: "RT 02", status: "Proses"),
    RWReport(judul: "Lampu PJU Mati", rt: "RT 01", status: "Selesai"),
    RWReport(judul: "Selokan Tersumbat", rt: "RT 04", status: "Menunggu"),
  ];

  static final Map<String, int> rekap = {
    "Total Laporan": 43,
    "Selesai": 28,
    "Proses": 10,
    "Menunggu": 5,
  };
}