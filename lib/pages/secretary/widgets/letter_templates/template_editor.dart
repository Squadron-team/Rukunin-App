import 'package:flutter/material.dart';

class TemplateEditor extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const TemplateEditor({required this.onSave, super.key});

  @override
  State<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends State<TemplateEditor> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Template')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(
                labelText: 'Isi Template',
                alignLabelWithHint: true,
              ),
              minLines: 8,
              maxLines: 20,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              onPressed: () {
                widget.onSave({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'title': titleCtrl.text,
                  'content': contentCtrl.text,
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
