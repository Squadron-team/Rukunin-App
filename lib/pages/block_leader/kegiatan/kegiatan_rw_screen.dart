import 'package:flutter/material.dart';
import 'models/kegiatan.dart';
import 'data/dummy_kegiatan.dart';
import 'widgets/kegiatan_header.dart';
import 'widgets/kegiatan_stat_cards.dart';
import 'widgets/kegiatan_filters.dart';
import 'widgets/kegiatan_card.dart';
import 'widgets/kegiatan_form.dart';

class KegiatanRwScreen extends StatefulWidget {
  const KegiatanRwScreen({super.key});

  @override
  State<KegiatanRwScreen> createState() => _KegiatanRwScreenState();
}

class _KegiatanRwScreenState extends State<KegiatanRwScreen> {
  List<Kegiatan> displayed = [];
  String selectedStatus = "Semua";

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

        final matchSearch = k.nama.toLowerCase().contains(q) ||
            k.kategori.toLowerCase().contains(q) ||
            k.lokasi.toLowerCase().contains(q);

        final matchStatus =
            selectedStatus == "Semua" || k.status == selectedStatus;

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
      backgroundColor: Color(0xfff8f9fc),
      appBar: AppBar(
        title: Text("Kegiatan RW"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => KegiatanForm(onSubmit: addKegiatan),
          );
        },
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          KegiatanHeader(),
          KegiatanStatCards(),
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
                ? Center(child: Text("Tidak ada kegiatan"))
                : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: displayed.length,
                    itemBuilder: (_, i) => KegiatanCard(kegiatan: displayed[i]),
                  ),
          )
        ],
      ),
    );
  }
}
