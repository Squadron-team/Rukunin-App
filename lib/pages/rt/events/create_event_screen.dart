import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/models/event.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/events/widgets/event_form.dart';

class CreateEventScreen extends StatefulWidget {
  final Event? initialEvent;

  const CreateEventScreen({this.initialEvent, super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool get isEdit => widget.initialEvent != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Text(isEdit ? 'Edit Kegiatan RT' : 'Buat Kegiatan RT', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lengkapi detail kegiatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Isi form di bawah untuk membuat kegiatan RT', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 16),

                // Use shared EventForm widget
                EventForm(
                  initialEvent: widget.initialEvent,
                  submitLabel: isEdit ? 'Simpan' : 'Simpan',
                  onSubmit: (ev) => Navigator.pop(context, ev),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
