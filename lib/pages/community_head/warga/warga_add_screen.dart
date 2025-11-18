import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaAddScreen extends StatefulWidget {
  const WargaAddScreen({super.key});

  @override
  State<WargaAddScreen> createState() => _WargaAddScreenState();
}

class _WargaAddScreenState extends State<WargaAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final nikC = TextEditingController();
  final kkC = TextEditingController();
  final addressC = TextEditingController();
  String rt = '01';
  String rw = '01';

  // placeholders for uploaded files
  String ktpPreview = '';
  String kkPreview = '';

  @override
  void dispose() {
    nameC.dispose();
    nikC.dispose();
    kkC.dispose();
    addressC.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Future<void> _pickKtp() async {
    // placeholders for uploaded files
    setState(() {
      ktpPreview = 'ktp_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Upload KTP berhasil'),
      backgroundColor: Colors.yellow[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _pickKk() async {
    setState(() {
      kkPreview = 'kk_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Upload KK berhasil'),
      backgroundColor: Colors.yellow[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Warga'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tambah Data Warga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('Lengkapi formulir di bawah untuk menambahkan warga baru', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            TextFormField(controller: nameC, decoration: _dec('Nama Lengkap'), validator: (v) => (v?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null),
                            const SizedBox(height: 12),
                            TextFormField(controller: nikC, decoration: _dec('NIK'), keyboardType: TextInputType.number, validator: (v) {
                              if (v == null || v.isEmpty) return 'NIK tidak boleh kosong';
                              if (v.length < 6) return 'NIK terlalu pendek';
                              return null;
                            }),
                            const SizedBox(height: 12),
                            TextFormField(controller: kkC, decoration: _dec('No. KK'), keyboardType: TextInputType.number),
                            const SizedBox(height: 12),
                            TextFormField(controller: addressC, decoration: _dec('Alamat'), maxLines: 3),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: _dec('RT').copyWith(fillColor: Colors.grey.shade100),
                                  initialValue: rt,
                                  readOnly: true,
                                  enabled: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  decoration: _dec('RW').copyWith(fillColor: Colors.grey.shade100),
                                  initialValue: rw,
                                  readOnly: true,
                                  enabled: false,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 16),

                            // Document uploads
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('KTP', style: TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 110,
                                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                                        child: Center(child: Text(ktpPreview.isEmpty ? 'Belum upload KTP' : 'Preview KTP')),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: const Size(0, 36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: _pickKtp,
                                          child: const Text('Upload'),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), minimumSize: const Size(0, 36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: () {},
                                          child: const Text('Lihat'),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('KK', style: TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 110,
                                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                                        child: Center(child: Text(kkPreview.isEmpty ? 'Belum upload KK' : 'Preview KK')),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: const Size(0, 36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: _pickKk,
                                          child: const Text('Upload'),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), minimumSize: const Size(0, 36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: () {},
                                          child: const Text('Lihat'),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: BorderSide(color: Colors.grey.shade300)),
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final newWarga = Warga(
                                    id: 'warga_${DateTime.now().millisecondsSinceEpoch}',
                                    name: nameC.text,
                                    nik: nikC.text,
                                    kkNumber: kkC.text,
                                    address: addressC.text,
                                    rt: rt,
                                    rw: rw,
                                    isActive: true,
                                    ktpUrl: ktpPreview,
                                    kkUrl: kkPreview,
                                    createdAt: DateTime.now(),
                                  );
                                  Navigator.pop(context, newWarga);
                                }
                              },
                              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
