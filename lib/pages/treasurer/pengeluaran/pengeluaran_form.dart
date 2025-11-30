import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/treasurer/pemasukan/manual_review_page.dart'
    as pemasukan_review;
import 'package:rukunin/pages/treasurer/pemasukan/widgets/proof_area.dart'
    as pemasukan_widgets;
import 'package:rukunin/pages/treasurer/pemasukan/widgets/detection_result_sheet.dart'
    as pemasukan_widgets2;
import 'package:rukunin/pages/treasurer/pemasukan/widgets/camera_capture.dart'
    as pemasukan_camera;
import 'package:rukunin/pages/treasurer/pengeluaran/widgets/pengeluaran_header.dart';
import 'package:rukunin/pages/treasurer/pengeluaran/widgets/form_fields_card.dart';
import 'package:rukunin/pages/treasurer/pengeluaran/widgets/notes_card.dart';
import 'package:rukunin/pages/treasurer/pengeluaran/widgets/submit_button.dart';

enum ProofMode { photo, manual }

enum DetectionState { success, warning, error }

class PengeluaranForm extends StatefulWidget {
  const PengeluaranForm({super.key});

  @override
  State<PengeluaranForm> createState() => _PengeluaranFormState();
}

class _PengeluaranFormState extends State<PengeluaranForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _category;
  DateTime? _pickedDate;
  ProofMode _proofMode = ProofMode.photo;
  final ImagePicker _picker = ImagePicker();

  Uint8List? _pickedBytes;
  List<List<double>> _detections = [];
  bool _detectionRan = false;
  DetectionState? _detectionState;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _pickedDate = picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        if (mounted) _showAppSnack('Ukuran file maksimal 5MB');
        return;
      }
      setState(() {
        _pickedBytes = bytes;
        _detections = [];
        _detectionRan = false;
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) _showAppSnack('Gagal memilih gambar: $e');
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_proofMode == ProofMode.photo && _pickedBytes == null) {
      _showAppSnack('Unggah bukti pengeluaran terlebih dahulu');
      return;
    }
    _showAppSnack('Catatan pengeluaran disimpan');
    Navigator.of(context).pop();
  }

  Widget _buildProofArea() {
    return pemasukan_widgets.ProofArea(
      isPhotoMode: _proofMode == ProofMode.photo,
      pickedBytes: _pickedBytes,
      detectionRan: _detectionRan,
      hasDetections: _detections.isNotEmpty,
      onPickGallery: () => _pickImage(ImageSource.gallery),
      onPickCamera: _openCameraCapture,
      onRunDetection: _runDetection,
      onClearImage: () => setState(() => _pickedBytes = null),
    );
  }

  Future<void> _openCameraCapture() async {
    try {
      final bytes = await Navigator.of(context).push<Uint8List?>(
        MaterialPageRoute(
          builder: (ctx) => const pemasukan_camera.CameraCapturePage(),
        ),
      );
      if (bytes != null) {
        if (bytes.length > 5 * 1024 * 1024) {
          _showAppSnack('Ukuran file maksimal 5MB');
          return;
        }
        setState(() {
          _pickedBytes = bytes;
          _detections = [];
          _detectionRan = false;
        });
      }
    } catch (e) {
      debugPrint('Camera capture error: $e');
      if (mounted) _showAppSnack('Gagal membuka kamera');
    }
  }

  Future<void> _runDetection() async {
    if (_pickedBytes == null) {
      if (mounted) _showAppSnack('Pilih foto terlebih dahulu');
      return;
    }
    setState(() {
      _detections = [];
      _detectionRan = false;
      _detectionState = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    if (_pickedBytes!.lengthInBytes < 20 * 1024) {
      setState(() {
        _detectionState = DetectionState.error;
        _detectionRan = true;
        _detections = [];
      });
      _showDetectionResult();
      return;
    }
    final r = Random().nextDouble();
    if (r < 0.7) {
      setState(() {
        _detectionState = DetectionState.success;
        _detections = [
          [0.08, 0.12, 0.5, 0.12],
        ];
        _detectionRan = true;
      });
    } else if (r < 0.9) {
      setState(() {
        _detectionState = DetectionState.warning;
        _detections = [
          [0.3, 0.2, 0.4, 0.12],
        ];
        _detectionRan = true;
      });
    } else {
      setState(() {
        _detectionState = DetectionState.error;
        _detections = [];
        _detectionRan = true;
      });
    }
    _showDetectionResult();
  }

  void _showAppSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PengeluaranHeader(),
          FormFieldsCard(
            category: _category,
            onCategoryChanged: (v) => setState(() => _category = v),
            amountCtrl: _amountCtrl,
            pickedDate: _pickedDate,
            onPickDate: _pickDate,
          ),

          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bukti Transaksi',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              RadioListTile<ProofMode>(
                title: const Text('Transfer (Foto Struk)'),
                value: ProofMode.photo,
                groupValue: _proofMode,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _proofMode = v!),
              ),
              RadioListTile<ProofMode>(
                title: const Text('Tunai (Uang Asli)'),
                value: ProofMode.manual,
                groupValue: _proofMode,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _proofMode = v!),
              ),
              const SizedBox(height: 8),
              _buildProofArea(),
            ],
          ),

          const SizedBox(height: 12),
          NotesCard(notesCtrl: _notesCtrl),
          const SizedBox(height: 16),
          SubmitButton(onPressed: _submit),
        ],
      ),
    );
  }

  void _showDetectionResult() {
    final stateStr = (_detectionState != null)
        ? (_detectionState == DetectionState.success
              ? 'success'
              : (_detectionState == DetectionState.warning
                    ? 'warning'
                    : 'error'))
        : (_detections.isNotEmpty ? 'success' : 'error');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return pemasukan_widgets2.DetectionResultSheet(
          state: stateStr,
          imageBytes: _pickedBytes,
          onAccept: () {
            Navigator.of(context).pop();
            _submit();
          },
          onManualReview: () async {
            Navigator.of(context).pop();
            if (_pickedBytes == null) return;
            final result = await Navigator.of(context)
                .push<pemasukan_review.ManualReviewResult>(
                  MaterialPageRoute(
                    builder: (ctx) => pemasukan_review.ManualReviewPage(
                      imageBytes: _pickedBytes!,
                    ),
                  ),
                );
            if (result == pemasukan_review.ManualReviewResult.accept) {
              _submit();
            } else if (result == pemasukan_review.ManualReviewResult.reject) {
              setState(() {
                _pickedBytes = null;
                _detections = [];
                _detectionRan = false;
                _detectionState = null;
              });
              _showAppSnack('Pengeluaran ditolak');
            }
          },
          onReject: () {
            setState(() {
              _pickedBytes = null;
              _detections = [];
              _detectionRan = false;
              _detectionState = null;
            });
            Navigator.of(context).pop();
            _showAppSnack('Pengeluaran ditolak');
          },
          onReupload: () {
            Navigator.of(context).pop();
            _pickImage(ImageSource.gallery);
          },
        );
      },
    );
  }
}
