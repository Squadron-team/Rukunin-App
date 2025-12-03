import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';

class MinutesDetailPage extends StatelessWidget {
  final MinutesModel minutes;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MinutesDetailPage({
    required this.minutes,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(minutes.title),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Tanggal: ${minutes.date}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Peserta:\n${minutes.participants}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Notulensi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(minutes.notes, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
