import 'package:flutter/material.dart';

class OnboardingState {
  // KTP Data Controllers
  final nikController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final addressController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();
  final kelurahanController = TextEditingController();
  final kecamatanController = TextEditingController();

  // KK Data Controllers
  final kkNumberController = TextEditingController();
  final headOfFamilyController = TextEditingController();

  DateTime? birthdate;
  String? gender;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? education;
  String? relationToHead;

  void dispose() {
    nikController.dispose();
    birthPlaceController.dispose();
    addressController.dispose();
    rtController.dispose();
    rwController.dispose();
    kelurahanController.dispose();
    kecamatanController.dispose();
    kkNumberController.dispose();
    headOfFamilyController.dispose();
  }

  bool validateKTPData(BuildContext context) {
    if (nikController.text.isEmpty ||
        birthPlaceController.text.isEmpty ||
        birthdate == null ||
        gender == null ||
        addressController.text.isEmpty ||
        rtController.text.isEmpty ||
        rwController.text.isEmpty ||
        kelurahanController.text.isEmpty ||
        kecamatanController.text.isEmpty ||
        religion == null ||
        maritalStatus == null ||
        occupation == null) {
      _showSnackBar(context, 'Mohon lengkapi semua data KTP', Colors.orange);
      return false;
    }
    if (nikController.text.length != 16) {
      _showSnackBar(context, 'NIK harus 16 digit', Colors.red);
      return false;
    }
    return true;
  }

  bool validateKKData(BuildContext context) {
    if (kkNumberController.text.isEmpty ||
        headOfFamilyController.text.isEmpty ||
        relationToHead == null) {
      _showSnackBar(
        context,
        'Mohon lengkapi semua data Kartu Keluarga',
        Colors.orange,
      );
      return false;
    }
    if (kkNumberController.text.length != 16) {
      _showSnackBar(context, 'Nomor KK harus 16 digit', Colors.red);
      return false;
    }
    return true;
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
