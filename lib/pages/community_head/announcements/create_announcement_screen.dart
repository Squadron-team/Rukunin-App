import 'package:flutter/material.dart';
import 'package:rukunin/models/announcementRT.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ann = Announcement(
      id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      body: _body.text.trim(),
      createdAt: DateTime.now(),
      author: 'Ketua RT',
    );

    Navigator.pop(context, ann);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          const Text('Buat Pengumuman', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Isi detail pengumuman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Pengumuman akan dikirim sebagai broadcast ke seluruh warga RT', style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(height: 6),
                  TextFormField(controller: _title, decoration: buildInputDecoration('Judul Pengumuman'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul diperlukan' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _body, decoration: buildInputDecoration('Isi Pengumuman'), maxLines: 6, validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi pengumuman harus diisi' : null),
                ]),
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                    child: const Text('Kirim Pengumuman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),

              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}
