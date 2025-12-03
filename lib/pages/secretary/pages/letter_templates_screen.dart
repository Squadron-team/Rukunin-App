import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/letter_templates/template_item.dart';
import 'package:rukunin/pages/secretary/widgets/letter_templates/empty_template.dart';
import 'package:rukunin/pages/secretary/widgets/letter_templates/template_detail.dart';
import 'package:rukunin/pages/secretary/widgets/letter_templates/template_editor.dart';

class LetterTemplatesScreen extends StatefulWidget {
  const LetterTemplatesScreen({super.key});

  @override
  State<LetterTemplatesScreen> createState() => _LetterTemplatesScreenState();
}

class _LetterTemplatesScreenState extends State<LetterTemplatesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> templates = [
    {
      'id': '1',
      'title': 'Surat Izin',
      'content': 'Dengan hormat,\nSaya mengajukan izin ...',
    },
    {
      'id': '2',
      'title': 'Surat Undangan',
      'content': 'Dengan ini kami mengundang ...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase().trim();

    final filtered = templates.where((t) {
      return t['title'].toLowerCase().contains(query) ||
          t['content'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Letter Templates'), elevation: 0),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TemplateEditor(
                onSave: (newTemplate) {
                  setState(() {
                    templates.add(newTemplate);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Cari template...',
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const EmptyTemplate()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];

                      return TemplateItem(
                        title: item['title'],
                        content: item['content'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TemplateDetail(
                                title: item['title'],
                                content: item['content'],
                              ),
                            ),
                          );
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
