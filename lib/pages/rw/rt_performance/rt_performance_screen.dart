import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/rw/rt_performance/rt_performance_service.dart';

class RtPerformanceScreen extends StatefulWidget {
  const RtPerformanceScreen({super.key});

  @override
  State<RtPerformanceScreen> createState() => _RtPerformanceScreenState();
}

class _RtPerformanceScreenState extends State<RtPerformanceScreen> {
  final service = RtPerformanceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text('Performa RT'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: service.fetchRtPerformance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _barChart(data),
              const SizedBox(height: 16),
              ...data.map((rt) => _rtCard(context, rt)),
            ],
          );
        },
      ),
    );
  }

  // =============================
  // BAR CHART (CUSTOM)
  // =============================
  Widget _barChart(List<Map<String, dynamic>> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Performa RT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((rt) {
              final score = rt['score'] as int;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: score.toDouble(),
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(rt['rt'], style: const TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // =============================
  // RT CARD
  // =============================
  Widget _rtCard(BuildContext context, Map<String, dynamic> rt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          rt['rt'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Skor: ${rt['score']}%'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/rw/rt-performance/detail', extra: rt);
        },
      ),
    );
  }
}
