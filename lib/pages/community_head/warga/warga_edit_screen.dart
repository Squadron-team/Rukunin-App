import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaEditScreen extends StatefulWidget {
  final Warga warga;

  const WargaEditScreen({required this.warga, super.key});

  @override
  State<WargaEditScreen> createState() => _WargaEditScreenState();
}

class _WargaEditScreenState extends State<WargaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameC;
  late TextEditingController nikC;
  late TextEditingController kkC;
  late TextEditingController addressC;
  late String rt;
  late String rw;
  bool isActive = true;

  String ktpPreview = '';
  String kkPreview = '';

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.warga.name);
    nikC = TextEditingController(text: widget.warga.nik);
    kkC = TextEditingController(text: widget.warga.kkNumber);
    addressC = TextEditingController(text: widget.warga.address);
    rt = widget.warga.rt;
    rw = widget.warga.rw;
    isActive = widget.warga.isActive;
    ktpPreview = widget.warga.ktpUrl;
    kkPreview = widget.warga.kkUrl;
  }

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
        title: const Text('Edit Warga'),
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
                      const Text('Edit Data Warga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('Ubah informasi warga berikut. RT/RW tidak dapat diubah.', style: TextStyle(color: Colors.grey[700])),
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
                              return null;
                            }),
                            const SizedBox(height: 12),
                            TextFormField(controller: kkC, decoration: _dec('No. KK'), keyboardType: TextInputType.number),
                            const SizedBox(height: 12),
                            TextFormField(controller: addressC, decoration: _dec('Alamat'), maxLines: 3),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(child: TextFormField(decoration: _dec('RT').copyWith(fillColor: Colors.grey.shade100), initialValue: rt, readOnly: true, enabled: false)),
                              const SizedBox(width: 12),
                              Expanded(child: TextFormField(decoration: _dec('RW').copyWith(fillColor: Colors.grey.shade100), initialValue: rw, readOnly: true, enabled: false)),
                            ]),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              value: isActive,
                              onChanged: (v) => setState(() => isActive = v),
                              title: const Text('Status Aktif'),
                            ),
                            const SizedBox(height: 12),

                            // Document uploads (use detail screen as reference for display)
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
                                        child: Center(child: Text(ktpPreview.isEmpty ? 'Belum ada KTP' : 'Preview KTP')),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: const Size(0,36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: _pickKtp,
                                          child: const Text('Upload'),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), minimumSize: const Size(0,36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
                                        child: Center(child: Text(kkPreview.isEmpty ? 'Belum ada KK' : 'Preview KK')),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: const Size(0,36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          onPressed: _pickKk,
                                          child: const Text('Upload'),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), minimumSize: const Size(0,36), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
                                  final edited = Warga(
                                    id: widget.warga.id,
                                    name: nameC.text,
                                    nik: nikC.text,
                                    kkNumber: kkC.text,
                                    address: addressC.text,
                                    rt: rt,
                                    rw: rw,
                                    isActive: isActive,
                                    ktpUrl: ktpPreview,
                                    kkUrl: kkPreview,
                                    createdAt: widget.warga.createdAt,
                                  );
                                  Navigator.pop(context, edited);
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
