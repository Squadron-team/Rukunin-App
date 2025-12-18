import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/monitoring/monitoring_socket_service.dart';

class MonitoringDashboardScreen extends StatefulWidget {
  const MonitoringDashboardScreen({super.key});

  @override
  State<MonitoringDashboardScreen> createState() =>
      _MonitoringDashboardScreenState();
}

class _MonitoringDashboardScreenState extends State<MonitoringDashboardScreen> {
  final socket = MonitoringSocketService();

  @override
  void initState() {
    super.initState();
    socket.connect();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text('Dashboard Monitoring'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: socket.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: data.map(_chartCard).toList(),
          );
        },
      ),
    );
  }

  Widget _chartCard(Map<String, dynamic> rt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rt['rt'], style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _bar('Laporan', rt['laporan'], Colors.red),
          _bar('Kegiatan', rt['kegiatan'], Colors.green),
        ],
      ),
    );
  }

  Widget _bar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 15,
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(color),
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
