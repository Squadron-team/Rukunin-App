import 'package:flutter/material.dart';

class OutgoingMailEditPage extends StatefulWidget {
  final String oldTitle;
  final String oldDate;
  final Function(String title, String date) onSave;

  const OutgoingMailEditPage({
    required this.oldTitle,
    required this.oldDate,
    required this.onSave,
    super.key,
  });

  @override
  State<OutgoingMailEditPage> createState() => _OutgoingMailEditPageState();
}

class _OutgoingMailEditPageState extends State<OutgoingMailEditPage> {
  late TextEditingController titleController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.oldTitle);
    dateController = TextEditingController(text: widget.oldDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Surat Keluar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Judul Surat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Tanggal Surat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.onSave(titleController.text, dateController.text);
                Navigator.pop(context);
              },
              child: const Text('Update', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
