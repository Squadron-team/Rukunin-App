import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/components/task_item.dart';

class PendingTasks extends StatelessWidget {
  const PendingTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pending_actions,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tugas Menunggu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TaskItem(
            '7 KK belum bayar iuran November',
            Icons.payment,
            Colors.red,
          ),
          const TaskItem(
            '2 pengajuan surat menunggu persetujuan',
            Icons.description,
            Colors.orange,
          ),
          const TaskItem(
            '3 laporan menunggu tindak lanjut',
            Icons.report_problem,
            Colors.orange,
          ),
          const TaskItem(
            '1 data warga baru perlu verifikasi',
            Icons.person_add,
            Colors.blue,
          ),
        ],
      ),
    );
  }
}
