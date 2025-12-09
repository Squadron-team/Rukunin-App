import 'package:flutter/material.dart';
import 'package:rukunin/modules/activities/models/activity.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/pages/rt/activities/widgets/activity_form.dart';

class EditActivityScreen extends StatelessWidget {
  final Activity activity;
  const EditActivityScreen({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Edit Kegiatan RT',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
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
                const Text(
                  'Ubah detail kegiatan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perbarui informasi kegiatan sesuai kebutuhan',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),

                EventForm(
                  initialActivity: activity,
                  submitLabel: 'Simpan Perubahan',
                  onSubmit: (activity) => Navigator.pop(context, activity),
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
