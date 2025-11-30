import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

// Import Widgets
import '../widgets/letter/info_card.dart';
import '../widgets/letter/section_title.dart';
import '../widgets/letter/letter_type_selector.dart';
import '../widgets/letter/letter_info_form.dart';
import '../widgets/letter/applicant_form.dart';
import '../widgets/letter/additional_info_form.dart';
import '../widgets/letter/action_buttons.dart';

class CreateLetterScreen extends StatefulWidget {
  const CreateLetterScreen({super.key});

  @override
  State<CreateLetterScreen> createState() => _CreateLetterScreenState();
}

class _CreateLetterScreenState extends State<CreateLetterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomorSuratController = TextEditingController();
  final namaPemohonController = TextEditingController();
  final nikController = TextEditingController();
  final alamatController = TextEditingController();
  final keteranganController = TextEditingController();

  String? selectedLetterType;
  String? selectedRT;
  String? selectedRW;
  DateTime? selectedDate;

  @override
  void dispose() {
    nomorSuratController.dispose();
    namaPemohonController.dispose();
    nikController.dispose();
    alamatController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  void showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void createLetter() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedLetterType == null) {
      showMsg("Silakan pilih jenis surat", Colors.orange);
      return;
    }

    if (selectedDate == null) {
      showMsg("Silakan pilih tanggal surat", Colors.orange);
      return;
    }

    if (selectedRT == null || selectedRW == null) {
      showMsg("Silakan pilih RT dan RW", Colors.orange);
      return;
    }

    showMsg("Surat berhasil dibuat!", Colors.green);
    Navigator.pop(context);
  }

  void previewLetter() {
    if (!_formKey.currentState!.validate()) return;
    showMsg("Fitur preview segera hadir", Colors.blue);
  }

  void saveDraft() {
    showMsg("Draft berhasil disimpan", Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Buat Surat Baru",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: saveDraft,
            icon: const Icon(Icons.drafts, size: 18),
            label: const Text("Simpan Draft"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const InfoCard(),
              const SizedBox(height: 24),

              const SectionTitle(title: "Jenis Surat"),
              const SizedBox(height: 12),

              LetterTypeSelector(
                selectedType: selectedLetterType,
                onSelect: (v) => setState(() => selectedLetterType = v),
              ),

              const SizedBox(height: 24),
              const SectionTitle(title: "Informasi Surat"),
              const SizedBox(height: 12),

              LetterInfoForm(
                nomorSurat: nomorSuratController,
                selectedDate: selectedDate,
                onDateSelect: (v) => setState(() => selectedDate = v),
              ),

              const SizedBox(height: 24),
              const SectionTitle(title: "Data Pemohon"),
              const SizedBox(height: 12),

              ApplicantForm(
                namaPemohon: namaPemohonController,
                nik: nikController,
                alamat: alamatController,
                selectedRT: selectedRT,
                selectedRW: selectedRW,
                onChangeRT: (v) => setState(() => selectedRT = v),
                onChangeRW: (v) => setState(() => selectedRW = v),
              ),

              const SizedBox(height: 24),
              const SectionTitle(title: "Keterangan Tambahan"),
              const SizedBox(height: 12),

              AdditionalInfoForm(
                controller: keteranganController,
              ),

              const SizedBox(height: 32),
              ActionButtons(
                onCreate: createLetter,
                onPreview: previewLetter,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
