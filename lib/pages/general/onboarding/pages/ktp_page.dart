import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/onboarding/state/onboarding_state.dart';
import 'package:rukunin/widgets/custom_text_field.dart';
import 'package:rukunin/widgets/custom_dropdown.dart';
import 'package:rukunin/widgets/date_picker_field.dart';
import 'package:rukunin/repositories/options.dart';
import 'package:rukunin/style/app_colors.dart';

class KTPPage extends StatefulWidget {
  final OnboardingState state;

  const KTPPage({required this.state, super.key});

  @override
  State<KTPPage> createState() => _KTPPageState();
}

class _KTPPageState extends State<KTPPage> {
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
                  Icons.badge,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data KTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Kartu Tanda Penduduk',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: widget.state.nikController,
            label: 'NIK',
            hint: '16 digit NIK',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 16,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.state.birthPlaceController,
            label: 'Tempat Lahir',
            hint: 'Kota kelahiran',
            icon: Icons.location_city,
          ),
          const SizedBox(height: 16),
          DatePickerField(
            label: 'Tanggal Lahir',
            selectedDate: widget.state.birthdate,
            onDateSelected: (date) {
              setState(() {
                widget.state.birthdate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomDropdown(
            label: 'Jenis Kelamin',
            value: widget.state.gender,
            items: genderOptions,
            icon: Icons.people,
            onChanged: (value) {
              setState(() {
                widget.state.gender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.state.addressController,
            label: 'Alamat',
            hint: 'Alamat lengkap',
            icon: Icons.home,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: widget.state.rtController,
                  label: 'RT',
                  hint: '000',
                  icon: Icons.location_on,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: widget.state.rwController,
                  label: 'RW',
                  hint: '000',
                  icon: Icons.location_on,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.state.kelurahanController,
            label: 'Kelurahan',
            hint: 'Nama kelurahan',
            icon: Icons.apartment,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.state.kecamatanController,
            label: 'Kecamatan',
            hint: 'Nama kecamatan',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          CustomDropdown(
            label: 'Agama',
            value: widget.state.religion,
            items: religionOptions,
            icon: Icons.church,
            onChanged: (value) {
              setState(() {
                widget.state.religion = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomDropdown(
            label: 'Status Perkawinan',
            value: widget.state.maritalStatus,
            items: maritalStatusOptions,
            icon: Icons.favorite,
            onChanged: (value) {
              setState(() {
                widget.state.maritalStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: TextEditingController(text: widget.state.occupation),
            label: 'Pekerjaan',
            hint: 'Pekerjaan saat ini',
            icon: Icons.work,
            onChanged: (value) => widget.state.occupation = value,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: TextEditingController(text: widget.state.education),
            label: 'Pendidikan Terakhir (Opsional)',
            hint: 'Contoh: S1, SMA, dll',
            icon: Icons.school,
            onChanged: (value) => widget.state.education = value,
          ),
        ],
      ),
    );
  }
}
