import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/theme/app_colors.dart';

class MarketplaceAddPage extends StatefulWidget {
  const MarketplaceAddPage({super.key});

  @override
  State<MarketplaceAddPage> createState() => _MarketplaceAddPageState();
}

class _MarketplaceAddPageState extends State<MarketplaceAddPage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController sellerC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController stockC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  String category = 'Makanan';
  bool isService = false;
  bool isActive = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameC.dispose();
    sellerC.dispose();
    phoneC.dispose();
    priceC.dispose();
    stockC.dispose();
    descriptionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tambah Produk/Jasa Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan produk atau jasa warga ke marketplace',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card Form
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informasi Produk',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _input(
                              'Nama Produk/Jasa',
                              nameC,
                              validator: (v) => v?.isEmpty ?? true
                                  ? 'Nama tidak boleh kosong'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              initialValue: category,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Makanan',
                                  child: Text('Makanan'),
                                ),
                                DropdownMenuItem(
                                  value: 'Minuman',
                                  child: Text('Minuman'),
                                ),
                                DropdownMenuItem(
                                  value: 'Jasa',
                                  child: Text('Jasa'),
                                ),
                                DropdownMenuItem(
                                  value: 'Lainnya',
                                  child: Text('Lainnya'),
                                ),
                              ],
                              decoration: _dec('Kategori'),
                              onChanged: (v) {
                                setState(() {
                                  category = v!;
                                  // Auto set isService if category is Jasa
                                  if (category == 'Jasa') {
                                    isService = true;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            _input(
                              'Harga',
                              priceC,
                              keyboardType: TextInputType.number,
                              prefixText: 'Rp ',
                              validator: (v) {
                                if (v?.isEmpty ?? true) {
                                  return 'Harga tidak boleh kosong';
                                }
                                if (int.tryParse(v!) == null) {
                                  return 'Harga harus berupa angka';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            _input(
                              'Deskripsi',
                              descriptionC,
                              maxLines: 4,
                              validator: (v) => v?.isEmpty ?? true
                                  ? 'Deskripsi tidak boleh kosong'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            const Divider(),
                            const SizedBox(height: 16),

                            const Text(
                              'Informasi Penjual',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _input(
                              'Nama Penjual',
                              sellerC,
                              validator: (v) => v?.isEmpty ?? true
                                  ? 'Nama penjual tidak boleh kosong'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            _input(
                              'No. Telepon',
                              phoneC,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v?.isEmpty ?? true) {
                                  return 'No. Telepon tidak boleh kosong';
                                }
                                if (v!.length < 10) {
                                  return 'No. Telepon minimal 10 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            const Divider(),
                            const SizedBox(height: 16),

                            const Text(
                              'Pengaturan Stok',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Checkbox untuk Jasa
                            CheckboxListTile(
                              value: isService,
                              onChanged: (v) => setState(() => isService = v!),
                              title: const Text(
                                'Ini adalah jasa (tidak perlu stok)',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                'Centang jika ini adalah layanan/jasa',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppColors.primary,
                            ),

                            if (!isService) ...[
                              const SizedBox(height: 12),
                              _input(
                                'Jumlah Stok',
                                stockC,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (!isService && (v?.isEmpty ?? true)) {
                                    return 'Stok tidak boleh kosong';
                                  }
                                  if (v != null &&
                                      v.isNotEmpty &&
                                      int.tryParse(v) == null) {
                                    return 'Stok harus berupa angka';
                                  }
                                  return null;
                                },
                              ),
                            ],

                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),

                            // Status Active
                            SwitchListTile(
                              value: isActive,
                              onChanged: (v) => setState(() => isActive = v),
                              title: const Text(
                                'Status Aktif',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                isActive
                                    ? 'Produk akan langsung muncul di marketplace'
                                    : 'Produk tidak akan muncul di marketplace',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              activeThumbColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              onPressed: () => context.pop(),
                              child: Text(
                                'Batal',
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: _handleSubmit,
                              child: const Text(
                                'Simpan Produk',
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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Implementasi simpan data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Produk berhasil ditambahkan ke marketplace'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      context.pop();
    }
  }

  Widget _input(
    String label,
    TextEditingController c, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      decoration: _dec(label, prefixText: prefixText),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  InputDecoration _dec(String label, {String? prefixText}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}
