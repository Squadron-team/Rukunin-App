import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/kegiatan/models/kegiatan.dart';
import 'package:rukunin/pages/rw/kegiatan/data/dummy_kegiatan.dart';
import 'package:rukunin/pages/rw/kegiatan/widgets/kegiatan_header.dart';
import 'package:rukunin/pages/rw/kegiatan/widgets/kegiatan_stat_cards.dart';
import 'package:rukunin/pages/rw/kegiatan/widgets/kegiatan_filters.dart';
import 'package:rukunin/pages/rw/kegiatan/widgets/kegiatan_card.dart';
import 'package:rukunin/pages/rw/kegiatan/widgets/kegiatan_form.dart';

class KegiatanRwScreen extends StatefulWidget {
  const KegiatanRwScreen({super.key});

  @override
  State<KegiatanRwScreen> createState() => _KegiatanRwScreenState();
}

class _KegiatanRwScreenState extends State<KegiatanRwScreen> {
  List<Kegiatan> displayed = [];
  String selectedStatus = 'Semua';

  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayed = DummyKegiatanData.kegiatanList;
  }

  void filter() {
    setState(() {
      displayed = DummyKegiatanData.kegiatanList.where((k) {
        final q = searchC.text.toLowerCase();

        final matchSearch =
            k.nama.toLowerCase().contains(q) ||
            k.kategori.toLowerCase().contains(q) ||
            k.lokasi.toLowerCase().contains(q);

        final matchStatus =
            selectedStatus == 'Semua' || k.status == selectedStatus;

        return matchSearch && matchStatus;
      }).toList();
    });
  }

  void addKegiatan(Kegiatan k) {
    setState(() {
      DummyKegiatanData.kegiatanList.add(k);
      filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fc),
      appBar: AppBar(title: const Text('Kegiatan RW')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => KegiatanForm(onSubmit: addKegiatan),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          const KegiatanHeader(),
          const KegiatanStatCards(),
          KegiatanFilters(
            controller: searchC,
            selectedStatus: selectedStatus,
            onStatusChanged: (v) {
              selectedStatus = v;
              filter();
            },
            onSearchChanged: filter,
          ),

          Expanded(
            child: displayed.isEmpty
                ? const Center(child: Text('Tidak ada kegiatan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: displayed.length,
                    itemBuilder: (_, i) => KegiatanCard(kegiatan: displayed[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
