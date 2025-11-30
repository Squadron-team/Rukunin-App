import 'package:flutter/material.dart';

class TambahSuratScreen extends StatefulWidget {
  const TambahSuratScreen({super.key});

  @override
  State<TambahSuratScreen> createState() => _TambahSuratScreenState();
}

class _TambahSuratScreenState extends State<TambahSuratScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedJenisSurat;
  final _pemohonController = TextEditingController();
  final _alamatController = TextEditingController();
  final _keperluanController = TextEditingController();

  final List<String> _jenisSuratList = [
    'Surat Keterangan Domisili',
    'Surat Pengantar KTP',
    'Surat Keterangan Tidak Mampu',
    'Surat Keterangan Usaha',
    'Surat Pengantar SKCK',
    'Surat Keterangan Pindah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Surat Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Jenis Surat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
              value: _selectedJenisSurat,
              items: _jenisSuratList.map((jenis) {
                return DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJenisSurat = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Pilih jenis surat';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pemohonController,
              decoration: InputDecoration(
                labelText: 'Nama Pemohon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama pemohon';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.home),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan alamat';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _keperluanController,
              decoration: InputDecoration(
                labelText: 'Keperluan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit_note),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan keperluan';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buat Surat',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Implementasi simpan surat
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Surat berhasil dibuat')),
      );
    }
  }

  @override
  void dispose() {
    _pemohonController.dispose();
    _alamatController.dispose();
    _keperluanController.dispose();
    super.dispose();
  }
}