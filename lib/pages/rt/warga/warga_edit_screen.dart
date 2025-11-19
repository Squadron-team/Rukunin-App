import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_tile.dart';

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
    return buildInputDecoration(label);
  }

  

  Future<void> _pickKtp() async {
    setState(() {
      ktpPreview = 'ktp_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Upload KTP berhasil'),
      backgroundColor: AppColors.primary,
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
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          const Text('Edit Warga', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        foregroundColor: Colors.black,
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
                              if (v.length < 6) return 'NIK terlalu pendek';
                              return null;
                            }),
                            const SizedBox(height: 12),
                            TextFormField(controller: kkC, decoration: _dec('No. KK'), keyboardType: TextInputType.number, validator: (v) {
                              if (v == null || v.isEmpty) return 'No. KK tidak boleh kosong';
                              return null;
                            }),
                            const SizedBox(height: 12),
                            TextFormField(controller: addressC, decoration: _dec('Alamat'), maxLines: 3, validator: (v) {
                              if (v == null || v.isEmpty) return 'Alamat tidak boleh kosong';
                              return null;
                            }),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(child: TextFormField(decoration: _dec('RT').copyWith(fillColor: Colors.grey.shade50), initialValue: rt, readOnly: true)),
                              const SizedBox(width: 12),
                              Expanded(child: TextFormField(decoration: _dec('RW').copyWith(fillColor: Colors.grey.shade50), initialValue: rw, readOnly: true)),
                            ]),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              value: isActive,
                              onChanged: (v) => setState(() => isActive = v),
                              title: const Text('Status Aktif'),
                              activeThumbColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 12),

                            // Document uploads (KTP / KK)
                            Row(
                              children: [
                                Expanded(
                                  child: DocTile(
                                    title: 'KTP',
                                    url: ktpPreview,
                                    onUpload: _pickKtp,
                                    onView: null,
                                    showUpload: true,
                                    showViewButton: false,
                                    onRemove: () => setState(() => ktpPreview = ''),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DocTile(
                                    title: 'KK',
                                    url: kkPreview,
                                    onUpload: _pickKk,
                                    onView: null,
                                    showUpload: true,
                                    showViewButton: false,
                                    onRemove: () => setState(() => kkPreview = ''),
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
