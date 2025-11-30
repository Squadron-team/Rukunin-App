import 'package:flutter/material.dart';

class TambahRapatRwScreen extends StatefulWidget {
  const TambahRapatRwScreen({super.key});

  @override
  State<TambahRapatRwScreen> createState() => _TambahRapatRwScreenState();
}

class _TambahRapatRwScreenState extends State<TambahRapatRwScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController judulC = TextEditingController();
  final TextEditingController tanggalC = TextEditingController();
  final TextEditingController waktuC = TextEditingController();
  final TextEditingController lokasiC = TextEditingController();
  final TextEditingController agendaC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rapat RW')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: judulC,
                decoration: const InputDecoration(labelText: 'Judul Rapat'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: tanggalC,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: waktuC,
                decoration: const InputDecoration(labelText: 'Waktu'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: lokasiC,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: agendaC,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Agenda'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'judul': judulC.text,
                      'tanggal': tanggalC.text,
                      'waktu': waktuC.text,
                      'lokasi': lokasiC.text,
                      'agenda': agendaC.text,
                    });
                  }
                },
                child: const Text('Simpan Rapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
