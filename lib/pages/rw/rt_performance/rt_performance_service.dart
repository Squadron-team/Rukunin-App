class RtPerformanceService {
  Future<List<Map<String, dynamic>>> fetchRtPerformance() async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi API

    return [
      {'rt': 'RT 01', 'score': 85, 'laporan': 12, 'kegiatan': 8},
      {'rt': 'RT 02', 'score': 72, 'laporan': 9, 'kegiatan': 6},
      {'rt': 'RT 03', 'score': 90, 'laporan': 15, 'kegiatan': 10},
      {'rt': 'RT 04', 'score': 68, 'laporan': 7, 'kegiatan': 5},
      {'rt': 'RT 05', 'score': 80, 'laporan': 11, 'kegiatan': 7},
    ];
  }
}
