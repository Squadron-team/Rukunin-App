import 'package:flutter/material.dart';

class RtPerformanceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> rt;

  const RtPerformanceDetailScreen({required this.rt, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: Text(rt['rt']),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard('Skor Performa', '${rt['score']}%'),
            _infoCard('Jumlah Laporan', rt['laporan'].toString()),
            _infoCard('Jumlah Kegiatan', rt['kegiatan'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
