import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';

class EditMinutesScreen extends StatefulWidget {
  final MinutesModel minutes;

  const EditMinutesScreen({required this.minutes, super.key});

  @override
  State<EditMinutesScreen> createState() => _EditMinutesScreenState();
}

class _EditMinutesScreenState extends State<EditMinutesScreen> {
  late TextEditingController _title;
  late TextEditingController _date;
  late TextEditingController _participants;
  late TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.minutes.title);
    _date = TextEditingController(text: widget.minutes.date);
    _participants = TextEditingController(text: widget.minutes.participants);
    _notes = TextEditingController(text: widget.minutes.notes);
  }

  void _save() {
    final updated = widget.minutes.copyWith(
      title: _title.text,
      date: _date.text,
      participants: _participants.text,
      notes: _notes.text,
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Notulensi')),
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
            ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
