import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/kegiatan/models/kegiatan.dart';

class KegiatanForm extends StatefulWidget {
  final Function(Kegiatan) onSubmit;

  const KegiatanForm({required this.onSubmit, super.key});

  @override
  State<KegiatanForm> createState() => _KegiatanFormState();
}

class _KegiatanFormState extends State<KegiatanForm> {
  final _formKey = GlobalKey<FormState>();

  final namaC = TextEditingController();
  final deskC = TextEditingController();
  final lokasiC = TextEditingController();
  final penyelenggaraC = TextEditingController();
  final kontakC = TextEditingController();
  final kuotaC = TextEditingController();

  DateTime? tanggal;
  TimeOfDay? waktu;

  String kategori = 'Sosial';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Kegiatan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(namaC, 'Nama Kegiatan'),
              _input(deskC, 'Deskripsi'),
              _input(lokasiC, 'Lokasi'),

              DropdownButtonFormField(
                initialValue: kategori,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: ['Sosial', 'Keagamaan', 'Olahraga', 'Kebersihan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => kategori = v!),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  tanggal = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  setState(() {});
                },
                child: Text(tanggal == null ? 'Pilih Tanggal' : tanggal.toString()),
              ),

              ElevatedButton(
                onPressed: () async {
                  waktu = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {});
                },
                child: Text(waktu == null ? 'Pilih Waktu' : waktu!.format(context)),
              ),

              _input(kuotaC, 'Kuota Peserta', isNumber: true),
              _input(penyelenggaraC, 'Penyelenggara'),
              _input(kontakC, 'Kontak'),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            widget.onSubmit(
              Kegiatan(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nama: namaC.text,
                deskripsi: deskC.text,
                tanggal: tanggal ?? DateTime.now(),
                waktu: waktu?.format(context) ?? '-',
                lokasi: lokasiC.text,
                kategori: kategori,
                status: 'Akan Datang',
                peserta: 0,
                kuota: int.tryParse(kuotaC.text) ?? 0,
                penyelenggara: penyelenggaraC.text,
                kontak: kontakC.text,
                iconUrl: '🎉',
                color: Colors.blue,
              ),
            );

            Navigator.pop(context);
          },
          child: const Text('Tambah'),
        ),
      ],
    );
  }

  Widget _input(TextEditingController c, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
    );
  }
}
