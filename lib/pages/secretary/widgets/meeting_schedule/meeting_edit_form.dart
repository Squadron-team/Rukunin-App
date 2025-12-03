import 'package:flutter/material.dart';

class MeetingEditForm extends StatefulWidget {
  final Map<String, String> meeting;

  const MeetingEditForm({required this.meeting, super.key});

  @override
  State<MeetingEditForm> createState() => _MeetingEditFormState();
}

class _MeetingEditFormState extends State<MeetingEditForm> {
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController locationController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.meeting['title']);
    dateController = TextEditingController(text: widget.meeting['date']);
    timeController = TextEditingController(text: widget.meeting['time']);
    locationController = TextEditingController(
      text: widget.meeting['location'],
    );
    descController = TextEditingController(text: widget.meeting['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Rapat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _input('Judul', titleController),
            _input('Tanggal', dateController),
            _input('Waktu', timeController),
            _input('Lokasi', locationController),
            _input('Deskripsi', descController, maxLines: 3),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                  'location': locationController.text,
                  'description': descController.text,
                });
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
