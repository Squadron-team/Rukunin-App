import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/models/category.dart';
import 'package:rukunin/repositories/category_repository.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class KategoriFormScreen extends StatefulWidget {
  final Category? edit;
  const KategoriFormScreen({super.key, this.edit});

  @override
  State<KategoriFormScreen> createState() => _KategoriFormScreenState();
}

class _KategoriFormScreenState extends State<KategoriFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String _type = 'pengeluaran';
  final _targetCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _deadline;

  final CategoryRepository repo = CategoryRepository();

  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      _nameCtrl.text = widget.edit!.name;
      _type = widget.edit!.type;
      if (widget.edit!.targetPerFamily != null) {
        _targetCtrl.text = widget.edit!.targetPerFamily.toString();
      }
      _startDate = widget
          .edit!
          .deadline; // if existing only deadline stored in model; keep as start for backward compat
      _deadline = widget.edit!.deadline;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (res != null) setState(() => _startDate = res);
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (res != null) setState(() => _deadline = res);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id =
        widget.edit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final c = Category(
      id: id,
      name: _nameCtrl.text.trim(),
      type: _type,
      targetPerFamily: _type == 'iuran' && _targetCtrl.text.isNotEmpty
          ? int.tryParse(_targetCtrl.text)
          : null,
      startDate: _type == 'iuran' ? _startDate : null,
      deadline: _type == 'iuran' ? _deadline : null,
    );
    // basic validation for iuran dates
    if (_type == 'iuran') {
      if ((_targetCtrl.text).isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Target per keluarga wajib diisi'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_startDate == null || _deadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih tanggal mulai dan tenggat'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_startDate!.isAfter(_deadline!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tanggal mulai harus sebelum tenggat'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }
    if (widget.edit == null) {
      repo.add(c);
    } else {
      repo.update(c);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kategori "${c.name}" berhasil disimpan'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.edit == null ? 'Tambah Kategori' : 'Edit Kategori',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
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
                  Text(
                    widget.edit == null ? 'Tambah Kategori' : 'Edit Kategori',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola kategori pemasukan/pengeluaran/iuran di sistem.',
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
                          controller: _nameCtrl,
                          decoration: buildInputDecoration('Nama kategori'),
                          validator: (v) => (v ?? '').trim().isEmpty
                              ? 'Nama wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _type,
                          items: const [
                            DropdownMenuItem(
                              value: 'pengeluaran',
                              child: Text('Pengeluaran'),
                            ),
                            DropdownMenuItem(
                              value: 'pemasukan',
                              child: Text('Pemasukan'),
                            ),
                            DropdownMenuItem(
                              value: 'iuran',
                              child: Text('Iuran Warga'),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _type = v ?? 'pengeluaran'),
                          decoration: buildInputDecoration('Tipe kategori'),
                        ),
                        if (_type == 'iuran') ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _targetCtrl,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration(
                              'Target per keluarga (Rp)',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _startDate == null
                                      ? 'Mulai: belum dipilih'
                                      : 'Mulai: ${_startDate!.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Pilih Mulai',
                                onPressed: _pickStartDate,
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _deadline == null
                                      ? 'Tenggat: belum dipilih'
                                      : 'Tenggat: ${_deadline!.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Pilih Tenggat',
                                onPressed: _pickEndDate,
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _save,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
