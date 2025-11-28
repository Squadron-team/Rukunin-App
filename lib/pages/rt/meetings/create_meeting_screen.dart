import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/meeting.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/pages/rt/warga/widgets/form_actions.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  final locationC = TextEditingController();
  final descC = TextEditingController();

  @override
  void dispose() {
    titleC.dispose();
    locationC.dispose();
    descC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: date ?? now, firstDate: now.subtract(const Duration(days: 365)), lastDate: now.add(const Duration(days: 365)));
    if (d != null) setState(() => date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: time ?? TimeOfDay(hour: 10, minute: 0));
    if (t != null) setState(() => time = t);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = date == null ? '' : DateFormat('yyyy-MM-dd').format(date!);
    final timeStr = time == null ? '' : time!.format(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('Buat Rapat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20)), foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Form Rapat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
                const SizedBox(height: 8),
                Text('Isi formulir untuk membuat rapat RT', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(children: [
                    TextFormField(controller: titleC, decoration: buildInputDecoration('Judul Rapat'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi judul' : null),
                    const SizedBox(height: 12),
                    GestureDetector(onTap: _pickDate, child: AbsorbPointer(child: TextFormField(decoration: buildInputDecoration('Tanggal'), controller: TextEditingController(text: dateStr), validator: (v) => (date == null) ? 'Pilih tanggal' : null))),
                    const SizedBox(height: 12),
                    GestureDetector(onTap: _pickTime, child: AbsorbPointer(child: TextFormField(decoration: buildInputDecoration('Waktu'), controller: TextEditingController(text: timeStr), validator: (v) => (time == null) ? 'Pilih waktu' : null))),
                    const SizedBox(height: 12),
                    TextFormField(controller: locationC, decoration: buildInputDecoration('Lokasi'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi lokasi' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: descC, decoration: buildInputDecoration('Deskripsi'), maxLines: 4),
                  ]),
                ),

                const SizedBox(height: 20),

                FormActions(onCancel: () => Navigator.pop(context), onSave: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final dt = DateTime(
                      date!.year,
                      date!.month,
                      date!.day,
                      time!.hour,
                      time!.minute,
                    );
                    final m = Meeting(id: 'rapat_${DateTime.now().millisecondsSinceEpoch}', title: titleC.text.trim(), dateTime: dt, location: locationC.text.trim(), description: descC.text.trim(), attendeesCount: 0, isAttending: false, createdAt: DateTime.now());
                    Navigator.pop(context, m);
                  }
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
