import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaEditPage extends StatefulWidget {
  final String name;
  final String alamat;
  final String status;

  const WargaEditPage({
    super.key,
    required this.name,
    required this.alamat,
    required this.status,
  });

  @override
  State<WargaEditPage> createState() => _WargaEditPageState();
}

class _WargaEditPageState extends State<WargaEditPage> {
  late TextEditingController nameC;
  late TextEditingController alamatC;
  late String status;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.name);
    alamatC = TextEditingController(text: widget.alamat);
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: "Edit Warga",
      currentIndex: 0,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500, // biar rapi di tablet & web
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ubah Data Warga",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card berisi form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _input("Nama Lengkap", nameC),
                          const SizedBox(height: 16),
                          _input("Alamat", alamatC),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: status,
                            items: const [
                              DropdownMenuItem(
                                  value: "Aktif", child: Text("Aktif")),
                              DropdownMenuItem(
                                  value: "Nonaktif", child: Text("Nonaktif")),
                            ],
                            decoration: _dec("Status Warga"),
                            onChanged: (v) => setState(() => status = v!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
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
                          // aksi simpan
                        },
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------- INPUT GENERATOR ----------------------
  Widget _input(String label, TextEditingController c) {
    return TextField(
      controller: c,
      decoration: _dec(label),
    );
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      filled: true,
      fillColor: Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}