import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/pages/treasurer/pemasukan/manual_review_page.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/proof_area.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/detection_result_sheet.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/pemasukan_header.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/form_fields_card.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/notes_card.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/submit_button.dart';
import 'package:rukunin/pages/treasurer/pemasukan/widgets/camera_capture.dart';

enum ProofMode { photo, manual }

enum DetectionState { success, warning, error }

class PemasukanForm extends StatefulWidget {
  const PemasukanForm({super.key});

  @override
  State<PemasukanForm> createState() => _PemasukanFormState();
}

class _PemasukanFormState extends State<PemasukanForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _source;
  DateTime? _pickedDate;
  ProofMode _proofMode = ProofMode.photo;
  final ImagePicker _picker = ImagePicker();

  Uint8List? _pickedBytes;
  // fractional rects (left, top, width, height) used to draw detection boxes
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
        if (mounted) {
          _showAppSnack('Ukuran file maksimal 5MB');
        }
        return;
      }
      setState(() {
        _pickedBytes = bytes;
        _detections = [];
        _detectionRan = false;
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        _showAppSnack('Gagal memilih gambar: $e');
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_proofMode == ProofMode.photo && _pickedBytes == null) {
      _showAppSnack('Unggah bukti transfer terlebih dahulu');
      return;
    }
    _showAppSnack('Catatan pemasukan disimpan');
    Navigator.of(context).pop();
  }

  Widget _buildProofArea() {
    return ProofArea(
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
      final Uint8List? bytes = await Navigator.of(context).push<Uint8List?>(
        MaterialPageRoute(builder: (ctx) => const CameraCapturePage()),
      );
      if (bytes == null) return;
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
      debugPrint('Error capturing camera image: $e');
      if (mounted) _showAppSnack('Gagal mengambil gambar: $e');
    }
  }

  Future<void> _runDetection() async {
    if (_pickedBytes == null) {
      if (mounted) _showAppSnack('Pilih foto terlebih dahulu');
      return;
    }
    // simulate detection
    setState(() {
      _detections = [];
      _detectionRan = false;
      _detectionState = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    // low-size => unreadable
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
      // success
      setState(() {
        _detectionState = DetectionState.success;
        _detections = [
          [0.08, 0.12, 0.5, 0.12],
          [0.1, 0.35, 0.35, 0.08],
          [0.6, 0.6, 0.32, 0.18],
        ];
        _detectionRan = true;
      });
    } else if (r < 0.9) {
      // warning
      setState(() {
        _detectionState = DetectionState.warning;
        _detections = [
          [0.3, 0.2, 0.4, 0.12],
        ];
        _detectionRan = true;
      });
    } else {
      // error
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
          const PemasukanHeader(),
          FormFieldsCard(
            source: _source,
            onSourceChanged: (v) => setState(() => _source = v),
            amountCtrl: _amountCtrl,
            pickedDate: _pickedDate,
            onPickDate: _pickDate,
          ),

          const SizedBox(height: 12),
          // Proof options
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
              // detailed area
              _buildProofArea(),
            ],
          ),

          const SizedBox(height: 12),
          // Notes
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
        return DetectionResultSheet(
          state: stateStr,
          imageBytes: _pickedBytes,
          onAccept: () {
            Navigator.of(context).pop();
            _submit();
          },
          onManualReview: () async {
            Navigator.of(context).pop();
            if (_pickedBytes == null) return;
            final result = await Navigator.of(context).push<ManualReviewResult>(
              MaterialPageRoute(
                builder: (ctx) => ManualReviewPage(imageBytes: _pickedBytes!),
              ),
            );
            if (result == ManualReviewResult.accept) {
              _submit();
            } else if (result == ManualReviewResult.reject) {
              setState(() {
                _pickedBytes = null;
                _detections = [];
                _detectionRan = false;
                _detectionState = null;
              });
              _showAppSnack('Pemasukan ditolak');
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
            _showAppSnack('Pemasukan ditolak');
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
