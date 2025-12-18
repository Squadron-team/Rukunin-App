import 'package:flutter/material.dart';

class Letter {
  String title;
  String date;
  String description;

  Letter({required this.title, required this.date, required this.description});
}

class LetterHistoryScreen extends StatefulWidget {
  const LetterHistoryScreen({super.key});

  @override
  State<LetterHistoryScreen> createState() => _LetterHistoryScreenState();
}

class _LetterHistoryScreenState extends State<LetterHistoryScreen> {
  final List<Letter> _letters = [
    Letter(
      title: 'Surat Undangan Rapat',
      date: '01-12-2025',
      description: 'Rapat bulanan pengurus RT.',
    ),
    Letter(
      title: 'Surat Pemberitahuan',
      date: '15-12-2025',
      description: 'Pemberitahuan jadwal kegiatan warga.',
    ),
  ];

  void _deleteLetter(int index) {
    setState(() {
      _letters.removeAt(index);
    });
  }

  void _showAddEditDialog({Letter? letter, int? index}) {
    final titleController = TextEditingController(text: letter?.title ?? '');
    final dateController = TextEditingController(text: letter?.date ?? '');
    final descriptionController = TextEditingController(
      text: letter?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(letter == null ? 'Tambah Surat' : 'Edit Surat'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Surat'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Tanggal'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi / Isi Surat',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  dateController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }

              setState(() {
                if (letter == null) {
                  // Tambah baru
                  _letters.add(
                    Letter(
                      title: titleController.text,
                      date: dateController.text,
                      description: descriptionController.text,
                    ),
                  );
                } else {
                  // Edit
                  _letters[index!] = Letter(
                    title: titleController.text,
                    date: dateController.text,
                    description: descriptionController.text,
                  );
                }
              });

              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Letter letter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(letter.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal: ${letter.date}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(letter.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Surat')),
      body: _letters.isEmpty
          ? const Center(child: Text('Belum ada surat'))
          : ListView.builder(
              itemCount: _letters.length,
              itemBuilder: (context, index) {
                final letter = _letters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(letter.title),
                    subtitle: Text(letter.date),
                    onTap: () => _showDetailDialog(letter),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showAddEditDialog(letter: letter, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteLetter(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
