import 'package:flutter/material.dart';
import '../pages/rt/report_statistic/components/donut_chart.dart';
import 'package:rukunin/style/app_colors.dart';

class ReportRepository {
  // Totals 
  Map<String, int> getTotals() => {
        'Penduduk': 1240,
        'KK': 342,
        'Kelahiran': 18,
        'Kematian': 3,
      };

  // Age distribution
  Map<String, double> getAgeDistribution() => {
        'Anak': 240.0,
        'Remaja': 160.0,
        'Dewasa': 720.0,
        'Lansia': 120.0,
      };

  // Gender distribution
  Map<String, double> getGenderDistribution() => {
        'L': 630.0,
        'P': 610.0,
      };

  // Marriage status
  Map<String, double> getMarriageStatus() => {
        'Belum': 520.0,
        'Menikah': 650.0,
        'Cerai Hidup': 5.0,
        'Cerai Mati': 0.0,
      };

  // Births/deaths lists (per-period sample)
  List<int> getBirths() => [1, 3, 2, 4, 3, 2, 5];
  List<int> getDeaths() => [0, 1, 0, 1, 0, 1, 1];

  // Mobility sample (double values)
  List<double> getMobility() => [2.0, 4.0, 3.0, 6.0, 5.0, 7.0, 4.0, 6.0];

  // House segments 
  List<Segment> getHouseSegments() => [
        Segment('Berpenghuni', 420, AppColors.primary),
        Segment('Kosong', 40, Colors.grey),
        Segment('Kontrak', 60, Colors.orange),
      ];
}
