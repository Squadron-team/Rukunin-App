import 'package:flutter/material.dart';

class MeetingScheduleScreen extends StatelessWidget {
  const MeetingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Rapat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'Jadwal Rapat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman untuk mengelola jadwal rapat'),
          ],
        ),
      ),
    );
  }
}
