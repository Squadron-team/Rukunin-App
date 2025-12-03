import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/pages/secretary/widgets/resident/resident_card.dart';

class ResidentsDataScreen extends StatelessWidget {
  const ResidentsDataScreen({super.key});

  final List<Map<String, String>> dummyResidents = const [
    {
      'name': 'Budi Santoso',
      'nik': '1234567890123456',
      'address': 'Jl. Melati No. 5',
    },
    {
      'name': 'Siti Aminah',
      'nik': '1234567890123457',
      'address': 'Jl. Kenanga No. 12',
    },
    {
      'name': 'Ahmad Fauzi',
      'nik': '1234567890123458',
      'address': 'Jl. Mawar No. 8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(title: 'Data Warga', showNotification: false),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: dummyResidents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final resident = dummyResidents[index];
            return ResidentCard(
              name: resident['name']!,
              nik: resident['nik']!,
              address: resident['address']!,
              onTap: () {
                // Navigasi ke detail warga jika diperlukan
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi tambah warga baru
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
