import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/outgoing_mail/outgoing_mail_item.dart';
import 'package:rukunin/pages/secretary/widgets/outgoing_mail/outgoing_mail_detail_page.dart';
import 'package:rukunin/pages/secretary/widgets/outgoing_mail/outgoing_mail_form_page.dart';
import 'package:rukunin/pages/secretary/widgets/outgoing_mail/outgoing_mail_edit_page.dart';
import 'package:rukunin/pages/secretary/widgets/outgoing_mail/empty_outgoing_mail.dart';

class OutgoingMailScreen extends StatefulWidget {
  const OutgoingMailScreen({super.key});

  @override
  State<OutgoingMailScreen> createState() => _OutgoingMailScreenState();
}

class _OutgoingMailScreenState extends State<OutgoingMailScreen> {
  List<Map<String, String>> mails = [
    {'title': 'Surat Rekomendasi', 'date': '2 Desember 2025'},
    {'title': 'Surat Pemberitahuan', 'date': '1 Desember 2025'},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredMails = mails.where((mail) {
      return mail['title']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Keluar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [
          // SEARCHBAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari surat keluar...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredMails.isEmpty
                ? const EmptyOutgoingMail()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMails.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final mail = filteredMails[index];

                      return OutgoingMailItem(
                        title: mail['title']!,
                        date: mail['date']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OutgoingMailDetailPage(
                                title: mail['title']!,
                                date: mail['date']!,
                              ),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OutgoingMailEditPage(
                                oldTitle: mail['title']!,
                                oldDate: mail['date']!,
                                onSave: (newTitle, newDate) {
                                  setState(() {
                                    mail['title'] = newTitle;
                                    mail['date'] = newDate;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() => mails.remove(mail));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OutgoingMailFormPage(
                onSave: (title, date) {
                  setState(() {
                    mails.add({'title': title, 'date': date});
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
