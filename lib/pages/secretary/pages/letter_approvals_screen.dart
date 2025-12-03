import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/secretary/widgets/letter_approvals/approval_item.dart';
import 'package:rukunin/pages/secretary//widgets/letter_approvals/approval_filter_bar.dart';
import 'package:rukunin/pages/secretary/widgets/letter_approvals/empty_approval.dart';

class LetterApprovalsScreen extends StatefulWidget {
  const LetterApprovalsScreen({super.key});

  @override
  State<LetterApprovalsScreen> createState() => _LetterApprovalsScreenState();
}

class _LetterApprovalsScreenState extends State<LetterApprovalsScreen> {
  String selectedFilter = 'All';
  final TextEditingController searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> approvals = [
    {
      'title': 'Persetujuan Surat Undangan Rapat',
      'status': 'Pending',
      'date': '10 Desember 2025',
      'content': 'Isi surat undangan rapat...',
    },
    {
      'title': 'Persetujuan Surat Tugas',
      'status': 'Approved',
      'date': '08 Desember 2025',
      'content': 'Isi surat tugas...',
    },
    {
      'title': 'Persetujuan Surat Keterangan',
      'status': 'Rejected',
      'date': '05 Desember 2025',
      'content': 'Isi surat keterangan...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final query = searchCtrl.text.toLowerCase();

    final filtered = approvals.where((item) {
      final matchSearch = item['title'].toLowerCase().contains(query);
      final matchFilter =
          selectedFilter == 'All' || item['status'] == selectedFilter;

      return matchSearch && matchFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Letter Approvals')),

      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari surat...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔽 Filter Tabs
          ApprovalFilterBar(
            selected: selectedFilter,
            onSelect: (f) => setState(() => selectedFilter = f),
          ),

          // 📄 List Data
          Expanded(
            child: filtered.isEmpty
                ? const EmptyApproval()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];

                      return ApprovalItem(
                        data: item,
                        onTap: () {
                          context.push(
                            '/secretary/letter-approvals/detail',
                            extra: item,
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
