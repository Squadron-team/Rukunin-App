import 'package:flutter/material.dart';
import 'package:rukunin/modules/auth/state/onboarding_state.dart';
import 'package:rukunin/widgets/custom_text_field.dart';
import 'package:rukunin/widgets/custom_dropdown.dart';
import 'package:rukunin/repositories/options.dart';
import 'package:rukunin/theme/app_colors.dart';

class KKPage extends StatefulWidget {
  final OnboardingState state;

  const KKPage({required this.state, super.key});

  @override
  State<KKPage> createState() => _KKPageState();
}

class _KKPageState extends State<KKPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Kartu Keluarga',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Informasi Keluarga',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: widget.state.kkNumberController,
            label: 'Nomor Kartu Keluarga',
            hint: '16 digit nomor KK',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 16,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.state.headOfFamilyController,
            label: 'Nama Kepala Keluarga',
            hint: 'Nama lengkap kepala keluarga',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          CustomDropdown(
            label: 'Hubungan dengan Kepala Keluarga',
            value: widget.state.relationToHead,
            items: familyRelationOptions,
            icon: Icons.people_alt,
            onChanged: (value) {
              setState(() {
                widget.state.relationToHead = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pastikan data yang Anda masukkan sesuai dengan KK yang terdaftar',
                    style: TextStyle(fontSize: 13, color: Colors.amber[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
