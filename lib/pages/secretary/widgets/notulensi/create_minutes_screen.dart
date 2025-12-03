import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';

class CreateMinutesScreen extends StatefulWidget {
  const CreateMinutesScreen({super.key});

  @override
  State<CreateMinutesScreen> createState() => _CreateMinutesScreenState();
}

class _CreateMinutesScreenState extends State<CreateMinutesScreen> {
  final _title = TextEditingController();
  final _date = TextEditingController();
  final _participants = TextEditingController();
  final _notes = TextEditingController();

  void _save() {
    if (_title.text.isEmpty || _date.text.isEmpty) return;

    final minutes = MinutesModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text,
      date: _date.text,
      participants: _participants.text,
      notes: _notes.text,
    );

    Navigator.pop(context, minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Notulensi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Judul Rapat'),
            ),
            TextField(
              controller: _date,
              decoration: const InputDecoration(labelText: 'Tanggal'),
            ),
            TextField(
              controller: _participants,
              decoration: const InputDecoration(labelText: 'Peserta'),
            ),
            TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notulensi'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
