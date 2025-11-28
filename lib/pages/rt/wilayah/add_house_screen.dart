import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/models/house.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/input_decorations.dart';

class AddHouseScreen extends StatefulWidget {
  final Street street;
  final Set<int>? existingHouseNumbers;

  const AddHouseScreen({
    required this.street,
    this.existingHouseNumbers,
    super.key,
  });

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final houseNoC = TextEditingController();

  @override
  void dispose() {
    houseNoC.dispose();
    super.dispose();
  }

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
              'Tambah Rumah',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah Rumah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan nomor rumah pada jalan ${widget.street.name}. Status akan otomatis diset sebagai tidak berpenghuni.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: houseNoC,
                          decoration: buildInputDecoration('Nomor Rumah'),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Nomor rumah tidak boleh kosong';
                            final parsed = int.tryParse(v.trim());
                            if (parsed == null || parsed <= 0)
                              return 'Masukkan nomor rumah yang valid';
                            if (widget.existingHouseNumbers != null &&
                                widget.existingHouseNumbers!.contains(parsed))
                              return 'Nomor rumah sudah terdaftar';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final number = int.parse(houseNoC.text.trim());
                      // double-check duplicate before returning
                      if (widget.existingHouseNumbers != null &&
                          widget.existingHouseNumbers!.contains(number)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nomor rumah sudah terdaftar'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      final id =
                          '${widget.street.name.replaceAll(' ', '_')}_house_${number}_${DateTime.now().millisecondsSinceEpoch}';
                      final newHouse = House(
                        id: id,
                        streetName: widget.street.name,
                        houseNo: number,
                        isOccupied: false,
                      );
                      Navigator.pop(context, newHouse);
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
