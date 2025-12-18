import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class PeraturanAddPage extends StatefulWidget {
  const PeraturanAddPage({super.key});

  @override
  State<PeraturanAddPage> createState() => _PeraturanAddPageState();
}

class _PeraturanAddPageState extends State<PeraturanAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiPeraturanController = TextEditingController();

  String? _selectedKategori;
  DateTime _selectedDate = DateTime.now();

  final List<String> _kategoriList = [
    'Ketertiban',
    'Kebersihan',
    'Keuangan',
    'Fasilitas',
    'Sosial',
    'Lainnya',
  ];

  @override
  void dispose() {
    _judulController.dispose();
    _isiPeraturanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Oct',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategori == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih kategori peraturan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Simpan data ke database atau state management

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peraturan berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman list
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Tambah Peraturan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= JUDUL PERATURAN =====================
              const Text(
                'Judul Peraturan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul peraturan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul peraturan tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= KATEGORI =====================
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedKategori,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  hint: const Text('Pilih kategori'),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _kategoriList.map((kategori) {
                    return DropdownMenuItem(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================= TANGGAL PENETAPAN =====================
              const Text(
                'Tanggal Penetapan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= ISI PERATURAN =====================
              const Text(
                'Isi Peraturan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _isiPeraturanController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Masukkan isi peraturan secara lengkap...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi peraturan tidak boleh kosong';
                  }
                  if (value.length < 20) {
                    return 'Isi peraturan minimal 20 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // ================= BUTTONS =====================
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[400]!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
