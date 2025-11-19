import 'package:flutter/material.dart';
import 'package:rukunin/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/utils/date_formatter.dart';
import 'package:rukunin/widgets/input_decorations.dart';

typedef EventFormSubmit = void Function(Event event);

class EventForm extends StatefulWidget {
  final Event? initialEvent;
  final EventFormSubmit onSubmit;
  final String submitLabel;

  const EventForm({required this.onSubmit, this.initialEvent, this.submitLabel = 'Simpan', super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _category = 'Sosial';
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  bool get isEdit => widget.initialEvent != null;

  @override
  void initState() {
    super.initState();
    final i = widget.initialEvent;
    if (i != null) {
      _category = i.category;
      try {
        _date = DateFormatter.fullDate.parse(i.date);
      } catch (_) {
        _date = DateTime.now();
      }
      try {
        final parts = i.time.split(':');
        final h = int.parse(parts[0]);
        final m = int.parse(parts.length > 1 ? parts[1] : '0');
        _time = TimeOfDay(hour: h, minute: m);
      } catch (_) {}
      _titleCtrl.text = i.title;
      _locationCtrl.text = i.location;
      _descriptionCtrl.text = i.description;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sosial':
        return Colors.green;
      case 'rapat':
        return Colors.blue;
      case 'pendidikan':
        return Colors.purple;
      case 'seni':
        return Colors.pink;
      case 'olahraga':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sosial':
        return Icons.people;
      case 'rapat':
        return Icons.meeting_room;
      case 'pendidikan':
        return Icons.school;
      case 'seni':
        return Icons.brush;
      case 'olahraga':
        return Icons.fitness_center;
      default:
        return Icons.label;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final event = Event(
      category: _category,
      title: _titleCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      date: DateFormatter.formatFull(_date),
      time: _time.format(context),
      categoryColor: _getCategoryColor(_category),
      description: _descriptionCtrl.text.trim(),
    );

    widget.onSubmit(event);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration dec(String label) => buildInputDecoration(label);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Sosial', 'Rapat', 'Pendidikan', 'Seni', 'Olahraga'].map((c) {
                    final sel = _category == c;
                    final color = _getCategoryColor(c);
                    final icon = _getCategoryIcon(c);
                    return GestureDetector(
                      onTap: () => setState(() => _category = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? color.withOpacity(0.18) : Colors.transparent,
                          border: Border.all(color: sel ? color : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 16, color: sel ? color : Colors.grey.shade700),
                            const SizedBox(width: 8),
                            Text(c, style: TextStyle(color: sel ? color : Colors.grey.shade800, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),
                const Text('Informasi Kegiatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(controller: _titleCtrl, decoration: dec('Judul Kegiatan'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul diperlukan' : null),
                const SizedBox(height: 12),

                Row(children: [
                  Expanded(child: GestureDetector(onTap: _pickDate, child: AbsorbPointer(child: TextFormField(decoration: dec('Tanggal'), controller: TextEditingController(text: DateFormatter.formatFull(_date)))))),
                  const SizedBox(width: 12),
                  Expanded(child: GestureDetector(onTap: _pickTime, child: AbsorbPointer(child: TextFormField(decoration: dec('Waktu'), controller: TextEditingController(text: _time.format(context)))))),
                ]),

                const SizedBox(height: 12),
                TextFormField(controller: _locationCtrl, decoration: dec('Lokasi'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Lokasi diperlukan' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _descriptionCtrl, decoration: dec('Deskripsi'), maxLines: 6, validator: (v) => (v == null || v.trim().isEmpty) ? 'Deskripsi diperlukan' : null),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: BorderSide(color: Colors.grey.shade300)),
                child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                child: Text(widget.submitLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
