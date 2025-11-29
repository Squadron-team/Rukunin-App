import 'package:flutter/material.dart';
import 'package:rukunin/models/mutasi.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/repositories/streets.dart' as streetRepo;
import 'package:rukunin/pages/rt/warga/widgets/warga_common_fields.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/pages/rt/warga/widgets/form_actions.dart';

class MutasiAddScreen extends StatefulWidget {
  const MutasiAddScreen({super.key});

  @override
  State<MutasiAddScreen> createState() => _MutasiAddScreenState();
}

class _MutasiAddScreenState extends State<MutasiAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String jenis = 'Pindah Rumah';

  // keluarga
  String? keluargaId;
  String keluargaName = '';
  String rumahLama = 'Jalan Mawar No. 1';

  // rumah baru
  List<Street> _streets = [];
  Street? _selectedStreet;
  int? _selectedHouseNo;

  final alasanC = TextEditingController();
  DateTime? tanggalMutasi;

  @override
  void initState() {
    super.initState();
    _streets = List<Street>.from(streetRepo.streets);
  }

  @override
  void dispose() {
    alasanC.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label) => buildInputDecoration(label);

  Future<void> _selectFamily() async {
    // simple bottom sheet with searchable list of dummy families
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FamilyPickerSheet();
      },
    );
    if (result != null) {
      setState(() {
        keluargaId = result['id'];
        keluargaName = result['name'] ?? '';
        rumahLama = result['house'] ?? '-';
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: tanggalMutasi ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (d != null) setState(() => tanggalMutasi = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Catat Mutasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
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
                    'Form Mutasi Keluarga',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Catat mutasi keluar atau pindah alamat untuk sebuah keluarga',
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
                        DropdownButtonFormField<String>(
                          initialValue: jenis,
                          decoration: _dec('Jenis Mutasi'),
                          items: ['Pindah Rumah', 'Keluar']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => jenis = v ?? 'Pindah Rumah'),
                        ),

                        const SizedBox(height: 12),

                        // keluarga selector
                        GestureDetector(
                          onTap: _selectFamily,
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: _dec('Keluarga').copyWith(
                                hintText: keluargaName.isEmpty
                                    ? 'Pilih keluarga'
                                    : null,
                                suffixIcon: const Icon(Icons.search),
                              ),
                              controller: TextEditingController(
                                text: keluargaName,
                              ),
                              validator: (v) => (keluargaId == null)
                                  ? 'Pilih keluarga'
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // rumah lama (read-only)
                        TextFormField(
                          decoration: _dec('Rumah Lama'),
                          controller: TextEditingController(text: rumahLama),
                          readOnly: true,
                        ),

                        const SizedBox(height: 12),

                        // rumah baru (only for pindah)
                        if (jenis == 'Pindah Rumah')
                          Column(
                            children: [
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
                            ],
                          ),

                        TextFormField(
                          controller: alasanC,
                          decoration: _dec('Alasan Mutasi'),
                          maxLines: 3,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Isi alasan mutasi'
                              : null,
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: _dec('Tanggal Mutasi'),
                              controller: TextEditingController(
                                text: tanggalMutasi == null
                                    ? ''
                                    : tanggalMutasi!
                                          .toLocal()
                                          .toString()
                                          .split(' ')
                                          .first,
                              ),
                              validator: (v) => (tanggalMutasi == null)
                                  ? 'Pilih tanggal mutasi'
                                  : null,
                            ),
                          ),
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
                        final rumahBaru =
                            (jenis == 'Pindah Rumah' &&
                                streetName.isNotEmpty &&
                                _selectedHouseNo != null)
                            ? '$streetName No. ${_selectedHouseNo!}'
                            : null;

                        final mutasi = Mutasi(
                          id: 'mutasi_${DateTime.now().millisecondsSinceEpoch}',
                          jenis: jenis,
                          keluargaId: keluargaId ?? 'unknown',
                          keluargaName: keluargaName,
                          rumahLama: rumahLama,
                          rumahBaru: rumahBaru,
                          alasan: alasanC.text.trim(),
                          tanggalMutasi: tanggalMutasi ?? DateTime.now(),
                          createdAt: DateTime.now(),
                        );
                        Navigator.pop(context, mutasi);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FamilyPickerSheet extends StatefulWidget {
  @override
  State<_FamilyPickerSheet> createState() => _FamilyPickerSheetState();
}

class _FamilyPickerSheetState extends State<_FamilyPickerSheet> {
  final TextEditingController q = TextEditingController();
  late List<Map<String, String>> _items;

  @override
  void initState() {
    super.initState();
    _items = List.generate(50, (i) {
      return {
        'id': 'fam_${i + 1}',
        'name': 'Keluarga Warga ${i + 1}',
        'house': 'Jalan Bunga No. ${10 + i}',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = q.text.isEmpty
        ? _items
        : _items
              .where(
                (e) => e['name']!.toLowerCase().contains(q.text.toLowerCase()),
              )
              .toList();
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: q,
                      decoration: buildInputDecoration('Cari keluarga')
                          .copyWith(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Cari keluarga...',
                          ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Tutup',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final f = filtered[index];
                        return ListTile(
                          title: Text(f['name']!),
                          subtitle: Text(f['house']!),
                          dense: true,
                          onTap: () => Navigator.pop(context, f),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
