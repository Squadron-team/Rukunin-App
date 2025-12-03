import 'package:flutter/material.dart';

class OutgoingMailFormPage extends StatefulWidget {
  final Function(String title, String date) onSave;

  const OutgoingMailFormPage({required this.onSave, super.key});

  @override
  State<OutgoingMailFormPage> createState() => _OutgoingMailFormPageState();
}

class _OutgoingMailFormPageState extends State<OutgoingMailFormPage> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Surat Keluar'),
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
                hintText: 'Masukkan judul surat',
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
                hintText: 'Contoh: 2 Desember 2025',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.onSave(titleController.text, dateController.text);
                Navigator.pop(context);
              },
              child: const Text('Simpan', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
