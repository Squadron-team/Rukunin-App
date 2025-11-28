import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/data_warga/models/warga_model.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/loading_indicator.dart';

class EditWargaScreen extends StatefulWidget {
  final Warga warga;

  const EditWargaScreen({required this.warga, super.key});

  @override
  State<EditWargaScreen> createState() => _EditWargaScreenState();
}

class _EditWargaScreenState extends State<EditWargaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _alamatController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _noTeleponController;

  // Dropdown values
  late String _selectedRT;
  late String _selectedJenisKelamin;
  late String _selectedPekerjaan;
  late String _selectedStatusPerkawinan;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _namaController = TextEditingController(text: widget.warga.nama);
    _nikController = TextEditingController(text: widget.warga.nik);
    _alamatController = TextEditingController(text: widget.warga.alamat);
    _tempatLahirController = TextEditingController(
      text: widget.warga.tempatLahir,
    );
    _tanggalLahirController = TextEditingController(
      text: widget.warga.tanggalLahir,
    );
    _noTeleponController = TextEditingController(text: widget.warga.noTelepon);

    _selectedRT = widget.warga.rt;
    _selectedJenisKelamin = widget.warga.jenisKelamin;
    _selectedPekerjaan = widget.warga.pekerjaan;
    _selectedStatusPerkawinan = widget.warga.statusPerkawinan;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Generate foto URL if name changed
      final fotoUrl = _namaController.text != widget.warga.nama
          ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_namaController.text)}&background=${_getRandomColor()}&color=fff&size=200'
          : widget.warga.fotoUrl;

      final updatedWarga = widget.warga.copyWith(
        nama: _namaController.text,
        nik: _nikController.text,
        alamat: _alamatController.text,
        rt: _selectedRT,
        jenisKelamin: _selectedJenisKelamin,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        noTelepon: _noTeleponController.text.isEmpty
            ? '-'
            : _noTeleponController.text,
        pekerjaan: _selectedPekerjaan,
        statusPerkawinan: _selectedStatusPerkawinan,
        fotoUrl: fotoUrl,
      );

      // Update dummy data
      DummyWargaData.updateWarga(widget.warga.id, updatedWarga);

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data warga berhasil diperbarui'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  String _getRandomColor() {
    final colors = [
      '4F46E5',
      'EC4899',
      '10B981',
      'F59E0B',
      '6366F1',
      'EF4444',
      '8B5CF6',
      '14B8A6',
      'F97316',
      '3B82F6',
      'A855F7',
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Data Warga',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 20),
            ),
            onPressed: _showDeleteDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Preview
            _buildProfilePreview(),
            const SizedBox(height: 24),

            _buildSection('Data Pribadi', Icons.person, [
              _buildTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nikController,
                label: 'NIK',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  if (value.length != 16) {
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Jenis Kelamin',
                icon: Icons.wc,
                value: _selectedJenisKelamin,
                items: ['Laki-laki', 'Perempuan'],
                onChanged: (value) {
                  setState(() => _selectedJenisKelamin = value!);
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tempatLahirController,
                label: 'Tempat Lahir',
                icon: Icons.location_city,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tempat lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDateField(
                controller: _tanggalLahirController,
                label: 'Tanggal Lahir',
                icon: Icons.cake,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Status Perkawinan',
                icon: Icons.favorite,
                value: _selectedStatusPerkawinan,
                items: [
                  'Belum Menikah',
                  'Menikah',
                  'Cerai Hidup',
                  'Cerai Mati',
                ],
                onChanged: (value) {
                  setState(() => _selectedStatusPerkawinan = value!);
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Alamat & Kontak', Icons.home, [
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
                icon: Icons.location_on,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'RT',
                icon: Icons.home_work,
                value: _selectedRT,
                items: List.generate(
                  12,
                  (i) => (i + 1).toString().padLeft(2, '0'),
                ),
                onChanged: (value) {
                  setState(() => _selectedRT = value!);
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _noTeleponController,
                label: 'No. Telepon (Opsional)',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Pekerjaan', Icons.work, [
              _buildDropdown(
                label: 'Pekerjaan',
                icon: Icons.business_center,
                value: _selectedPekerjaan,
                items: [
                  'Wiraswasta',
                  'PNS',
                  'Karyawan Swasta',
                  'Guru',
                  'Dokter',
                  'Perawat',
                  'Software Developer',
                  'Pengusaha',
                  'Arsitek',
                  'Desainer',
                  'Marketing',
                  'Akuntan',
                  'Insinyur',
                  'Pelajar/Mahasiswa',
                  'Ibu Rumah Tangga',
                  'Lainnya',
                ],
                onChanged: (value) {
                  setState(() => _selectedPekerjaan = value!);
                },
              ),
            ]),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(widget.warga.fotoUrl),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.warga.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.warga.nik,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RT ${widget.warga.rt} / RW ${widget.warga.rw}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          controller.text =
              '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: LoadingIndicator(),
              )
            : const Text(
                'Perbarui Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data Warga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ${widget.warga.nama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              DummyWargaData.deleteWarga(widget.warga.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Close edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data warga berhasil dihapus'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
