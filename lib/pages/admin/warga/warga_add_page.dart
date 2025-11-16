import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';

class WargaAddPage extends StatefulWidget {
  const WargaAddPage({super.key});

  @override
  State<WargaAddPage> createState() => _WargaAddPageState();
}

class _WargaAddPageState extends State<WargaAddPage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController alamatC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController noTelpC = TextEditingController();
  String status = "Aktif";
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameC.dispose();
    alamatC.dispose();
    nikC.dispose();
    noTelpC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: "Tambah Warga",
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tambah Data Warga Baru",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Lengkapi formulir di bawah untuk menambahkan warga baru",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
                            _input(
                              "Nama Lengkap",
                              nameC,
                              validator: (v) => v?.isEmpty ?? true
                                  ? "Nama tidak boleh kosong"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            
                            _input(
                              "NIK",
                              nikC,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v?.isEmpty ?? true) {
                                  return "NIK tidak boleh kosong";
                                }
                                if (v!.length != 16) {
                                  return "NIK harus 16 digit";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            _input(
                              "Alamat",
                              alamatC,
                              maxLines: 3,
                              validator: (v) => v?.isEmpty ?? true
                                  ? "Alamat tidak boleh kosong"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            
                            _input(
                              "No. Telepon",
                              noTelpC,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v?.isEmpty ?? true) {
                                  return "No. Telepon tidak boleh kosong";
                                }
                                if (v!.length < 10) {
                                  return "No. Telepon minimal 10 digit";
                                }
                                return null;
                              },
                            ),
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

                      // Tombol action
                      Row(
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Batal",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
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
                              onPressed: _handleSubmit,
                              child: const Text(
                                "Simpan Data",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------- HANDLE SUBMIT ----------------------
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Implementasi simpan data
      // Contoh: panggil API atau simpan ke database
      
      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Data warga berhasil ditambahkan"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      
      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  // ---------------------- INPUT GENERATOR ----------------------
  Widget _input(
    String label,
    TextEditingController c, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      decoration: _dec(label),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}