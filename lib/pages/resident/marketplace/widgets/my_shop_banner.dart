import 'package:flutter/material.dart';
import 'package:rukunin/models/shop.dart';
import 'package:rukunin/pages/resident/marketplace/shop_dashboard_screen.dart';
import 'package:rukunin/style/app_colors.dart';

class MyShopBanner extends StatelessWidget {
  final bool isHaveShop;

  const MyShopBanner({required this.isHaveShop, super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final Shop shop = Shop(
      id: '1',
      name: 'Toko Bu Siti',
      ownerId: 'user123',
      ownerName: 'Siti',
      description: 'Sayuran segar dan berkualitas',
      createdAt: DateTime.now(),
    );

    if (isHaveShop) return _buildMyShopBanner(context, shop);

    return _buildOpenShopBanner(context);
  }

  Widget _buildOpenShopBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(179)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.store, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingin buka toko sendiri?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai jualan di komunitas Anda',
                  style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to create shop
              _showCreateShopDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Buka Toko'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyShopBanner(BuildContext context, Shop shop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(76)),
      ),
      child: Row(
        children: [
          const Icon(Icons.store, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kelola toko Anda',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopDashboardScreen(shop: shop),
                ),
              );
            },
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Dashboard'),
          ),
        ],
      ),
    );
  }

  void _showCreateShopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buka Toko Baru'),
        content: const Text(
          'Fitur ini akan membuka formulir pendaftaran toko. Anda akan dapat mulai berjualan setelah toko Anda disetujui.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to shop registration form
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }
}
