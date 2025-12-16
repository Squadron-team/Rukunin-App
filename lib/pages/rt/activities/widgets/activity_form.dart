import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/models/activity.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/utils/formatter/date_formatter.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/modules/activities/services/activity_service.dart';

typedef ActivityFormSubmit = void Function(Activity activity);

class EventForm extends StatefulWidget {
  final Activity? initialActivity;
  final ActivityFormSubmit onSubmit;
  final String submitLabel;

  const EventForm({
    required this.onSubmit,
    this.initialActivity,
    this.submitLabel = 'Simpan',
    super.key,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final ActivityService _activityService = ActivityService();

  String _category = 'Sosial';
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  bool _isSubmitting = false;

  bool get isEdit => widget.initialActivity != null;

  @override
  void initState() {
    super.initState();
    final i = widget.initialActivity;
    if (i != null) {
      _category = i.category;
      _date = i.dateTime;
      _time = TimeOfDay(hour: i.dateTime.hour, minute: i.dateTime.minute);
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
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final eventDateTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      final activity = Activity(
        id: isEdit ? widget.initialActivity!.id : '',
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        category: _category,
        location: _locationCtrl.text.trim(),
        dateTime: eventDateTime,
        organizerId: isEdit ? widget.initialActivity!.organizerId : '',
        organizerName: isEdit ? widget.initialActivity!.organizerName : '',
        organizerPosition: isEdit
            ? widget.initialActivity!.organizerPosition
            : '',
        imageUrl: isEdit ? widget.initialActivity!.imageUrl : '',
        participants: isEdit ? widget.initialActivity!.participants : [],
        categoryColor: _getCategoryColor(_category),
        createdAt: isEdit ? widget.initialActivity!.createdAt : null,
      );

      String? docId;
      if (isEdit) {
        final success = await _activityService.updateEvent(
          activity.id,
          activity,
        );
        if (success) {
          docId = activity.id;
        }
      } else {
        docId = await _activityService.createEvent(activity);
      }

      if (!mounted) return;

      if (docId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Kegiatan berhasil diperbarui'
                  : 'Kegiatan berhasil dibuat',
            ),
            backgroundColor: Colors.green,
          ),
        );

        final finalActivity = activity.copyWith(id: docId);
        widget.onSubmit(finalActivity);
        Navigator.pop(context, finalActivity);
      } else {
        throw Exception('Failed to ${isEdit ? 'update' : 'create'} activity');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal ${isEdit ? 'memperbarui' : 'membuat'} kegiatan: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      ['Sosial', 'Rapat', 'Pendidikan', 'Seni', 'Olahraga'].map(
                        (c) {
                          final sel = _category == c;
                          final color = _getCategoryColor(c);
                          final icon = _getCategoryIcon(c);
                          return GestureDetector(
                            onTap: () => setState(() => _category = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? color.withOpacity(0.18)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: sel ? color : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: 16,
                                    color: sel ? color : Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    c,
                                    style: TextStyle(
                                      color: sel ? color : Colors.grey.shade800,
                                      fontWeight: sel
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                ),

                const SizedBox(height: 12),
                const Text(
                  'Informasi Kegiatan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: dec('Judul Kegiatan'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Judul diperlukan'
                      : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: dec('Tanggal'),
                            controller: TextEditingController(
                              text: DateFormatter.formatFull(_date),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickTime,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: dec('Waktu'),
                            controller: TextEditingController(
                              text: _time.format(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: dec('Lokasi'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Lokasi diperlukan'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: dec('Deskripsi'),
                  maxLines: 6,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Deskripsi diperlukan'
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
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
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          widget.submitLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
