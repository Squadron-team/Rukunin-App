import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/letter_archive/archive_item.dart';
import 'package:rukunin/pages/secretary/widgets/letter_archive/empty_archive.dart';

class LetterArchiveScreen extends StatefulWidget {
  const LetterArchiveScreen({super.key});

  @override
  State<LetterArchiveScreen> createState() => _LetterArchiveScreenState();
}

class _LetterArchiveScreenState extends State<LetterArchiveScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  List<Map<String, dynamic>> archives = [
    {'id': '1', 'title': 'Surat Keterangan Domisili', 'date': '12 Nov 2024'},
    {'id': '2', 'title': 'Surat Pengantar RT', 'date': '03 Okt 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    final query = searchCtrl.text.toLowerCase().trim();

    final filtered = archives.where((a) {
      return a['title'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Letter Archive')),

      body: Column(
        children: [
          // 🔍 Search Area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari arsip surat...',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const EmptyArchive()
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return ArchiveItem(
                        title: item['title'],
                        date: item['date'],
                        onTap: () {
                          // TODO: Detail page
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
