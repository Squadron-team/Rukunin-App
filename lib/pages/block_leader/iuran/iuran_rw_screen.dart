import 'package:flutter/material.dart';
import 'models/status_iuran.dart';
import 'widgets/iuran_header.dart';
import 'widgets/iuran_card.dart';
import 'widgets/iuran_section.dart';

class IuranRwScreen extends StatefulWidget {
  const IuranRwScreen({super.key});

  @override
  State<IuranRwScreen> createState() => _IuranRwScreenState();
}

class _IuranRwScreenState extends State<IuranRwScreen> {
  late List<StatusIuran> statusList;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    statusList = DummyStatusIuranData.data;
  }

  List<StatusIuran> get filteredList {
    if (searchQuery.isEmpty) return statusList;

    return statusList.where((item) {
      return item.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.nik.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int totalWarga = statusList.length;
    int sudahBayar = statusList.where((e) => e.sudahBayar).length;
    int belumBayar = totalWarga - sudahBayar;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Iuran RW"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // 🔎 SEARCH FIELD
            TextField(
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: "Cari nama atau NIK...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // HEADER
            IuranHeader(
              totalWarga: totalWarga,
              sudahBayar: sudahBayar,
              belumBayar: belumBayar,
            ),

            const IuranSection(title: "Daftar Iuran Warga"),

            // LIST CARD
            ...filteredList.map((item) => IuranCard(status: item)),
          ],
        ),
      ),
    );
  }
}
