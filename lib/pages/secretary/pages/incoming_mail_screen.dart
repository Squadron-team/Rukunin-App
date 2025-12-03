import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/incoming_mail/mail_item.dart';
import 'package:rukunin/pages/secretary/widgets/incoming_mail/empty_mail.dart';

class IncomingMailScreen extends StatelessWidget {
  const IncomingMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mails = [
      {
        'title': 'Undangan Rapat Koordinasi',
        'number': 'SM/001/2025',
        'date': '01 Desember 2025',
      },
      {
        'title': 'Pemberitahuan Libur Nasional',
        'number': 'SM/002/2025',
        'date': '25 November 2025',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text('Surat Masuk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.2,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Tambah Surat'),
        icon: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari surat...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: mails.isEmpty
                ? const EmptyMail()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: mails.length,
                    itemBuilder: (context, index) {
                      return MailItem(
                        title: mails[index]['title']!,
                        number: mails[index]['number']!,
                        date: mails[index]['date']!,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
