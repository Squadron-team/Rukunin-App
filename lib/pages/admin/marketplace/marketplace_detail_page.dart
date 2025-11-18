import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';

class MarketplaceDetailPage extends StatelessWidget {
  const MarketplaceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil arguments dari navigator
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    final String id = args['id'];
    final String name = args['name'];
    final String seller = args['seller'];
    final String phone = args['phone'];
    final int price = args['price'];
    final String category = args['category'];
    final String image = args['image'];
    final int stock = args['stock'];
    final bool isActive = args['isActive'];
    final String description = args['description'];

    bool isService = category == 'Jasa';

    return AdminLayout(
      title: 'Detail Produk',
      currentIndex: 3,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: isActive ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isActive ? 'Aktif' : 'Nonaktif',
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Image Card
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: Text(
                      image,
                      style: const TextStyle(fontSize: 120),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Product Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Info Cards Grid
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildInfoCard(
                      icon: Icons.store,
                      label: 'Penjual',
                      value: seller,
                      color: Colors.blue,
                    ),
                    _buildInfoCard(
                      icon: Icons.phone,
                      label: 'No. Telepon',
                      value: phone,
                      color: Colors.green,
                    ),
                    _buildInfoCard(
                      icon: Icons.attach_money,
                      label: 'Harga',
                      value: 'Rp ${_formatCurrency(price)}',
                      color: Colors.orange,
                    ),
                    if (!isService)
                      _buildInfoCard(
                        icon: Icons.inventory,
                        label: 'Stok',
                        value: '$stock ${stock > 0 ? "Tersedia" : "Habis"}',
                        color: stock > 0 ? Colors.green : Colors.red,
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
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
                      const Row(
                        children: [
                          Icon(Icons.description, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Deskripsi Produk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons for Admin
                Column(
                  children: [
                    // Edit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Produk',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/marketplace/edit',
                            arguments: args,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Toggle Active/Inactive
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: isActive ? Colors.orange : Colors.green,
                          ),
                        ),
                        icon: Icon(
                          isActive ? Icons.block : Icons.check_circle,
                          color: isActive ? Colors.orange : Colors.green,
                        ),
                        label: Text(
                          isActive ? 'Nonaktifkan Produk' : 'Aktifkan Produk',
                          style: TextStyle(
                            fontSize: 16,
                            color: isActive ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          _showToggleActiveDialog(context, name, isActive);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Delete Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Hapus Produk',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          _showDeleteDialog(context, name);
                        },
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
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showToggleActiveDialog(BuildContext context, String name, bool isActive) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Nonaktifkan Produk' : 'Aktifkan Produk'),
        content: Text(
          isActive
              ? 'Apakah Anda yakin ingin menonaktifkan "$name"? Produk tidak akan muncul di marketplace warga.'
              : 'Apakah Anda yakin ingin mengaktifkan "$name"? Produk akan muncul kembali di marketplace warga.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.orange : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? 'Produk berhasil dinonaktifkan'
                        : 'Produk berhasil diaktifkan',
                  ),
                  backgroundColor: isActive ? Colors.orange : Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              isActive ? 'Nonaktifkan' : 'Aktifkan',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "$name"? Tindakan ini tidak dapat dibatalkan.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produk berhasil dihapus'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}