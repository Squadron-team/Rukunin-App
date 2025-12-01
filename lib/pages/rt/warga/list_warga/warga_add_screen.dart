import 'package:flutter/material.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_tile.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/repositories/streets.dart' as streetRepo;
import 'package:rukunin/pages/rt/warga/widgets/warga_common_fields.dart';
import 'package:rukunin/pages/rt/warga/widgets/form_actions.dart';

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
  // address now selected via street + house number
  final addressC = TextEditingController();
  final placeC = TextEditingController();
  final pekerjaanC = TextEditingController();
  final maritalC = TextEditingController();
  final educationC = TextEditingController();
  DateTime? dateOfBirth;
  bool isHead = false;
  String gender = 'Laki-laki';

  List<Street> _streets = [];
  Street? _selectedStreet;
  int? _selectedHouseNo;
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
    placeC.dispose();
    pekerjaanC.dispose();
    maritalC.dispose();
    educationC.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label) {
    return buildInputDecoration(label);
  }

  Future<void> _pickKtp() async {
    setState(() {
      ktpPreview = 'ktp_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Upload KTP berhasil'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _pickKk() async {
    setState(() {
      kkPreview = 'kk_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Upload KK berhasil'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // load streets
    _streets = List<Street>.from(streetRepo.streets);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tambah Warga',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
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
                      const Text(
                        'Tambah Data Warga',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lengkapi formulir di bawah untuk menambahkan warga baru',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
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
                            TextFormField(
                              controller: nameC,
                              decoration: _dec('Nama Lengkap'),
                              validator: (v) => (v?.isEmpty ?? true)
                                  ? 'Nama tidak boleh kosong'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: nikC,
                              decoration: _dec('NIK'),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'NIK tidak boleh kosong';
                                }
                                if (v.length < 6) return 'NIK terlalu pendek';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: kkC,
                              decoration: _dec('No. KK'),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'No. KK tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            AddressPicker(
                              streets: _streets,
                              selectedStreet: _selectedStreet,
                              onStreetChanged: (v) =>
                                  setState(() => _selectedStreet = v),
                              selectedHouseNo: _selectedHouseNo,
                              onHouseChanged: (v) =>
                                  setState(() => _selectedHouseNo = v),
                            ),
                            const SizedBox(height: 12),
                            PersonalDetailsFields(
                              placeC: placeC,
                              dateOfBirth: dateOfBirth,
                              onDateChanged: (d) =>
                                  setState(() => dateOfBirth = d),
                              pekerjaanC: pekerjaanC,
                              maritalC: maritalC,
                              educationC: educationC,
                              isHead: isHead,
                              onIsHeadChanged: (v) =>
                                  setState(() => isHead = v),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: gender,
                              decoration: _dec('Jenis Kelamin'),
                              items: ['Laki-laki', 'Perempuan']
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => gender = v ?? 'Laki-laki'),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Pilih jenis kelamin'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: _dec(
                                      'RT',
                                    ).copyWith(fillColor: Colors.grey.shade50),
                                    initialValue: rt,
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    decoration: _dec(
                                      'RW',
                                    ).copyWith(fillColor: Colors.grey.shade50),
                                    initialValue: rw,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Document uploads
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
                                    onRemove: () =>
                                        setState(() => ktpPreview = ''),
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
                                    onRemove: () =>
                                        setState(() => kkPreview = ''),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      FormActions(
                        onCancel: () => Navigator.pop(context),
                        onSave: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final streetName = _selectedStreet?.name ?? '';
                            final addr =
                                (streetName.isNotEmpty &&
                                    _selectedHouseNo != null)
                                ? '$streetName No. ${_selectedHouseNo!}'
                                : addressC.text;
                            final newWarga = Warga(
                              id: 'warga_${DateTime.now().millisecondsSinceEpoch}',
                              name: nameC.text,
                              nik: nikC.text,
                              kkNumber: kkC.text,
                              address: addr,
                              rt: rt,
                              rw: rw,
                              isActive: true,
                              gender: gender,
                              isAlive: true,
                              ktpUrl: ktpPreview,
                              kkUrl: kkPreview,
                              createdAt: DateTime.now(),
                              placeOfBirth: placeC.text,
                              dateOfBirth: dateOfBirth,
                              pekerjaan: pekerjaanC.text,
                              maritalStatus: maritalC.text,
                              education: educationC.text,
                              isHead: isHead,
                            );
                            Navigator.pop(context, newWarga);
                          }
                        },
                      ),
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
