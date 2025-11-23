import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class WilayahAddScreen extends StatefulWidget {
  const WilayahAddScreen({super.key});

  @override
  State<WilayahAddScreen> createState() => _WilayahAddScreenState();
}

class _WilayahAddScreenState extends State<WilayahAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();

  InputDecoration _dec(String label) {
    return buildInputDecoration(label);
  }

  @override
  void dispose() {
    nameC.dispose();
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
          const Text('Tambah Wilayah', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5)),
        ]),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Tambah Wilayah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Tambahkan nama jalan/gang baru pada RT ini.', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(children: [
                    TextFormField(controller: nameC, decoration: _dec('Nama Jalan / Gang'), validator: (v) => (v?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null),
                  ]),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: BorderSide(color: Colors.grey.shade300)),
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final name = nameC.text.trim();
                    final newStreet = Street(name: name, totalHouses: 0);
                    Navigator.pop(context, {'street': newStreet});
                  }
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
