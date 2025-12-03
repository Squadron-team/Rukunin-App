import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_model.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_service.dart';

class MeetingForm extends StatefulWidget {
  const MeetingForm({super.key});

  @override
  State<MeetingForm> createState() => _MeetingFormState();
}

class _MeetingFormState extends State<MeetingForm> {
  final title = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();

  void saveMeeting() {
    final newMeeting = MeetingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.text,
      date: date.text,
      time: time.text,
      location: location.text,
      description: description.text,
    );

    MeetingService.addMeeting(newMeeting);

    Navigator.pop(context, newMeeting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rapat')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            field('Judul', title),
            field('Tanggal', date),
            field('Waktu', time),
            field('Lokasi', location),
            field('Deskripsi', description, maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveMeeting, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }

  Widget field(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
