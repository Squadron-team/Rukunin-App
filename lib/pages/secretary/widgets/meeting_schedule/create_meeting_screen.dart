import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/meeting_schedule/meeting_model.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveMeeting() {
    if (_formKey.currentState!.validate()) {
      final newMeeting = MeetingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        date: _dateController.text,
        time: _timeController.text,
        location: _locationController.text,
        description: _descriptionController.text,
      );

      Navigator.pop(context, newMeeting);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')} "
            '${_getMonthName(picked.month)} ${picked.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}."
            "${picked.minute.toString().padLeft(2, '0')} WIB";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text('Tambah Rapat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
        actions: [
          TextButton.icon(
            onPressed: _saveMeeting,
            icon: const Icon(Icons.check),
            label: const Text('Simpan'),
            style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
          ),
        ],
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Isi semua informasi untuk membuat jadwal rapat baru',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Judul
            _buildTextField(
              controller: _titleController,
              label: 'Judul Rapat',
              icon: Icons.title,
              hint: 'Contoh: Rapat Koordinasi Bulanan',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Tanggal
            _buildTextField(
              controller: _dateController,
              label: 'Tanggal',
              icon: Icons.calendar_today,
              hint: 'Pilih tanggal rapat',
              readOnly: true,
              onTap: _selectDate,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Waktu
            _buildTextField(
              controller: _timeController,
              label: 'Waktu',
              icon: Icons.access_time,
              hint: 'Pilih waktu rapat',
              readOnly: true,
              onTap: _selectTime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Waktu tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Lokasi
            _buildTextField(
              controller: _locationController,
              label: 'Lokasi',
              icon: Icons.location_on,
              hint: 'Contoh: Aula Balai Desa',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lokasi tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Deskripsi
            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi (Opsional)',
              icon: Icons.description,
              hint: 'Jelaskan tujuan atau agenda rapat',
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveMeeting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Rapat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
