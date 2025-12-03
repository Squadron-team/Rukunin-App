import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class CertificateFormScreen extends StatefulWidget {
  final Map<String, String>? initialData;

  const CertificateFormScreen({super.key, this.initialData});

  @override
  State<CertificateFormScreen> createState() => _CertificateFormScreenState();
}

class _CertificateFormScreenState extends State<CertificateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _residentController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialData?['title'] ?? '',
    );
    _residentController = TextEditingController(
      text: widget.initialData?['resident'] ?? '',
    );
    _dateController = TextEditingController(
      text: widget.initialData?['date'] ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _residentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Scaffold(
      appBar: RukuninAppBar(
        title: isEdit ? 'Edit Surat Keterangan' : 'Tambah Surat Keterangan',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Surat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Harap isi judul' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _residentController,
                decoration: const InputDecoration(
                  labelText: 'Nama Warga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Harap isi nama warga'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'DD MMM YYYY',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Harap isi tanggal' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final result = {
                      'title': _titleController.text,
                      'resident': _residentController.text,
                      'date': _dateController.text,
                    };
                    Navigator.pop(context, result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Surat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
