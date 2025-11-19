import 'package:flutter/material.dart';
import 'rapat_rw_card.dart';
import 'rapat_rw_detail.dart';
import 'tambah_rapat_rw_screen.dart';

class RapatRwScreen extends StatefulWidget {
  const RapatRwScreen({super.key});

  @override
  State<RapatRwScreen> createState() => _RapatRwScreenState();
}

class _RapatRwScreenState extends State<RapatRwScreen> {
  // DATA RAPAT (bisa ditambah & dihapus)
  List<Map<String, String>> rapatData = [
    {
      "judul": "Rapat Koordinasi Bulanan RW",
      "tanggal": "21 November 2025",
      "waktu": "19:00 WIB",
      "lokasi": "Balai RW 05",
      "agenda":
          "1. Evaluasi kegiatan bulan lalu\n2. Pembahasan keamanan lingkungan\n3. Rencana kerja bakti\n4. Usulan warga"
    },
    {
      "judul": "Rapat Pembahasan Anggaran",
      "tanggal": "15 November 2025",
      "waktu": "20:00 WIB",
      "lokasi": "Rumah Ketua RW",
      "agenda": "1. Laporan keuangan\n2. Dana kegiatan RT\n3. Proposal warga"
    },
  ];

  // Fungsi menghapus
  void hapusRapat(int index) {
    setState(() {
      rapatData.removeAt(index);
    });
  }

  // Fungsi menambah
  void tambahRapat(Map<String, String> rapatBaru) {
    setState(() {
      rapatData.add(rapatBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rapat RW")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahRapatRwScreen(),
            ),
          );

          if (result != null) {
            tambahRapat(result);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rapatData.length,
        itemBuilder: (context, index) {
          final rapat = rapatData[index];

          return GestureDetector(
            onLongPress: () {
              // Hapus dengan long press
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Hapus Rapat"),
                  content: const Text("Yakin ingin menghapus rapat ini?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        hapusRapat(index);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: RapatRwCard(
              judul: rapat["judul"]!,
              tanggal: rapat["tanggal"]!,
              waktu: rapat["waktu"]!,
              lokasi: rapat["lokasi"]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RapatRwDetail(
                      judul: rapat["judul"]!,
                      tanggal: rapat["tanggal"]!,
                      waktu: rapat["waktu"]!,
                      lokasi: rapat["lokasi"]!,
                      agenda: rapat["agenda"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
