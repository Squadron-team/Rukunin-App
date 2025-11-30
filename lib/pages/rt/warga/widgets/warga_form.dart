import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_tile.dart';
import 'package:rukunin/pages/rt/warga/widgets/warga_common_fields.dart';
import 'package:rukunin/widgets/input_decorations.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/models/street.dart';

class WargaForm extends StatelessWidget {
  final TextEditingController nameC;
  final TextEditingController nikC;
  final TextEditingController kkC;
  final TextEditingController addressC;
  final TextEditingController placeC;
  final TextEditingController pekerjaanC;
  final TextEditingController maritalC;
  final TextEditingController educationC;
  final DateTime? dateOfBirth;
  final bool isHead;
  final String gender;
  final bool isAlive;
  final bool isActive;
  final List<Street> streets;
  final Street? selectedStreet;
  final int? selectedHouseNo;
  final void Function(Street?) onStreetChanged;
  final void Function(int?) onHouseChanged;
  final void Function(DateTime?) onDateChanged;
  final void Function(bool) onIsHeadChanged;
  final void Function(String) onGenderChanged;
  final void Function(bool) onIsAliveChanged;
  final void Function(bool) onIsActiveChanged;
  final String ktpPreview;
  final String kkPreview;
  final VoidCallback onPickKtp;
  final VoidCallback onPickKk;

  const WargaForm({
    required this.nameC,
    required this.nikC,
    required this.kkC,
    required this.addressC,
    required this.placeC,
    required this.pekerjaanC,
    required this.maritalC,
    required this.educationC,
    required this.dateOfBirth,
    required this.isHead,
    required this.gender,
    required this.isAlive,
    required this.isActive,
    required this.streets,
    required this.selectedStreet,
    required this.selectedHouseNo,
    required this.onStreetChanged,
    required this.onHouseChanged,
    required this.onDateChanged,
    required this.onIsHeadChanged,
    required this.onGenderChanged,
    required this.onIsAliveChanged,
    required this.onIsActiveChanged,
    required this.ktpPreview,
    required this.kkPreview,
    required this.onPickKtp,
    required this.onPickKk,
    super.key,
  });

  InputDecoration _dec(String label) => buildInputDecoration(label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: nameC,
            decoration: _dec('Nama Lengkap'),
            validator: (v) =>
                (v?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: nikC,
            decoration: _dec('NIK'),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'NIK tidak boleh kosong';
              if (v.length < 6) return 'NIK terlalu pendek';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: kkC,
            decoration: _dec('No. KK'),
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'No. KK tidak boleh kosong' : null,
          ),
          const SizedBox(height: 12),
          AddressPicker(
            streets: streets,
            selectedStreet: selectedStreet,
            onStreetChanged: onStreetChanged,
            selectedHouseNo: selectedHouseNo,
            onHouseChanged: onHouseChanged,
          ),
          const SizedBox(height: 12),
          PersonalDetailsFields(
            placeC: placeC,
            dateOfBirth: dateOfBirth,
            onDateChanged: onDateChanged,
            pekerjaanC: pekerjaanC,
            maritalC: maritalC,
            educationC: educationC,
            isHead: isHead,
            onIsHeadChanged: onIsHeadChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: gender.isNotEmpty ? gender : null,
            decoration: _dec('Jenis Kelamin'),
            items: [
              'Laki-laki',
              'Perempuan',
            ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (v) => onGenderChanged(v ?? ''),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Pilih jenis kelamin' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: _dec(
                    'RT',
                  ).copyWith(fillColor: Colors.grey.shade50),
                  initialValue: streets.isNotEmpty && selectedStreet != null
                      ? selectedStreet!.name
                      : null,
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: _dec(
                    'RW',
                  ).copyWith(fillColor: Colors.grey.shade50),
                  initialValue: '01',
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: isActive,
            onChanged: onIsActiveChanged,
            title: const Text('Status Aktif'),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: isAlive,
            onChanged: onIsAliveChanged,
            title: const Text('Status Kehidupan'),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DocTile(
                  title: 'KTP',
                  url: ktpPreview,
                  onUpload: onPickKtp,
                  onView: null,
                  showUpload: true,
                  showViewButton: false,
                  onRemove: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DocTile(
                  title: 'KK',
                  url: kkPreview,
                  onUpload: onPickKk,
                  onView: null,
                  showUpload: true,
                  showViewButton: false,
                  onRemove: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
